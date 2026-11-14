import { Kysely, sql } from 'kysely';
import { CommandFactory } from 'nest-commander';
import { ChildProcess, fork } from 'node:child_process';
import { dirname, join } from 'node:path';
import { Worker } from 'node:worker_threads';
import { PostgresError } from 'postgres';
import { DatabaseLock, ExitCode, UniversalPhotosWorker, LogLevel, SystemMetadataKey } from 'src/enum.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { SystemMetadataRepository } from 'src/repositories/system-metadata.repository.js';
import { type DB } from 'src/schema/index.js';
import { getKyselyConfig } from 'src/utils/database.js';

/** Manages worker lifecycle */
class Workers {
  /** Currently running workers */
  workers: Partial<Record<UniversalPhotosWorker, { kill: (signal: NodeJS.Signals) => Promise<void> | void }>> = {};

  /** Fail-safe in case anything dies during restart */
  restarting = false;

  /** Boot all enabled workers */
  async bootstrap() {
    const isMaintenanceMode = await this.isMaintenanceMode();
    const { workers } = new ConfigRepository().getEnv();

    if (isMaintenanceMode) {
      this.startWorker(UniversalPhotosWorker.Maintenance);
    } else {
      await this.waitForFreeLock();

      for (const worker of workers) {
        this.startWorker(worker);
      }
    }
  }

  private async isMaintenanceMode(): Promise<boolean> {
    const { database } = new ConfigRepository().getEnv();
    const { log: _, ...kyselyConfig } = getKyselyConfig(database.config);
    const kysely = new Kysely<DB>(kyselyConfig);
    const systemMetadataRepository = new SystemMetadataRepository(kysely);

    try {
      const value = await systemMetadataRepository.get(SystemMetadataKey.MaintenanceMode);
      return value?.isMaintenanceMode || false;
    } catch (error: Error | any) {
      // Table doesn't exist (migrations haven't run yet)
      if ((error as PostgresError).code === '42P01') {
        return false;
      }

      throw error;
    } finally {
      await kysely.destroy();
    }
  }

  private async waitForFreeLock() {
    const { database } = new ConfigRepository().getEnv();
    const kysely = new Kysely<DB>(getKyselyConfig(database.config));

    let isLocked = false;
    while (!isLocked) {
      isLocked = await kysely.connection().execute(async (conn) => {
        const { rows } = await sql<{
          pg_try_advisory_lock: boolean;
        }>`SELECT pg_try_advisory_lock(${DatabaseLock.MaintenanceOperation})`.execute(conn);

        const isLocked = rows[0].pg_try_advisory_lock;

        if (isLocked) {
          await sql`SELECT pg_advisory_unlock(${DatabaseLock.MaintenanceOperation})`.execute(conn);
        }

        return isLocked;
      });

      if (!isLocked) {
        await new Promise((resolve) => setTimeout(resolve, 1000));
      }
    }

    await kysely.destroy();
  }

  /**
  Start an individual worker
  @param name Worker
  */
  private startWorker(name: UniversalPhotosWorker) {
    console.log(`Starting ${name} worker`);

    const basePath = dirname(import.meta.filename);
    const workerFile = join(basePath, 'workers', `${name}.js`);

    let anyWorker: Worker | ChildProcess;
    let kill: (signal?: NodeJS.Signals) => Promise<void> | void;

    if (name === UniversalPhotosWorker.Api) {
      const worker = fork(workerFile, [], {
        execArgv: process.execArgv.map((arg) => (arg.startsWith('--inspect') ? '--inspect=0.0.0.0:9231' : arg)),
      });

      kill = (signal) => void worker.kill(signal);
      // eslint-disable-next-line unicorn/prefer-hoisting-branch-code
      anyWorker = worker;
    } else {
      const worker = new Worker(workerFile);

      kill = async () => void (await worker.terminate());
      anyWorker = worker;
    }

    anyWorker.on('error', (error) => this.onError(name, error));
    anyWorker.on('exit', (exitCode) => this.onExit(name, exitCode));

    this.workers[name] = { kill };
  }

  onError(name: UniversalPhotosWorker, error: Error) {
    console.error(`${name} worker error: ${error}, stack: ${error.stack}`);
  }

  onExit(name: UniversalPhotosWorker, exitCode: number | null) {
    // restart universalphotos server
    if (exitCode === ExitCode.AppRestart || this.restarting) {
      this.restarting = true;

      console.info(`${name} worker shutdown for restart`);
      delete this.workers[name];

      // once all workers shut down, bootstrap again
      if (Object.keys(this.workers).length === 0) {
        void this.bootstrap();
        this.restarting = false;
      }

      return;
    }

    // shutdown the entire process
    delete this.workers[name];

    if (exitCode !== 0) {
      console.error(`${name} worker exited with code ${exitCode}`);

      if (Object.hasOwn(this.workers, UniversalPhotosWorker.Api) && name !== UniversalPhotosWorker.Api) {
        console.error('Killing api process');
        void this.workers[UniversalPhotosWorker.Api]!.kill('SIGTERM');
      }
    }

    process.exit(exitCode);
  }
}

async function main() {
  const universalphotosApp = process.argv[2];
  if (universalphotosApp) {
    process.argv.splice(2, 1);
  }

  if (universalphotosApp === 'universalphotos-admin') {
    process.title = 'universalphotos_admin_cli';
    process.env.UNIVERSALPHOTOS_LOG_LEVEL = LogLevel.Warn;

    // imported lazily, so that the supervisor process does not build the whole application
    // graph on every start.
    const { UniversalPhotosAdminModule } = await import('./app.module.js');

    return CommandFactory.run(UniversalPhotosAdminModule);
  }

  if (universalphotosApp === 'universalphotos' || universalphotosApp === 'microservices') {
    console.error(
      `Using "start.sh ${universalphotosApp}" has been deprecated. See https://github.com/yashhasan570/UniversalPhotos/releases/tag/v1.118.0 for more information.`,
    );
    process.exit(1);
  }

  if (universalphotosApp) {
    console.error(`Unknown command: "${universalphotosApp}"`);
    process.exit(1);
  }

  process.title = 'universalphotos';
  void new Workers().bootstrap();
}

void main();
