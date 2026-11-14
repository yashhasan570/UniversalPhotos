import { YuccaService as OrchestratorService, type UniversalPhotosDatabaseDumpConfig } from '@futo-org/backups-orchestrator-api';
import { Injectable, Optional } from '@nestjs/common';
import { basename } from 'node:path';
import { StorageCore } from 'src/cores/storage.core.js';
import { OnEvent } from 'src/decorators.js';
import type { SystemConfig } from 'src/dtos/config.dto.js';
import { UniversalPhotosWorker, MaintenanceAction, StorageFolder } from 'src/enum.js';
import type { ArgOf } from 'src/repositories/event.repository.js';
import { LibraryRepository } from 'src/repositories/library.repository.js';
import { DatabaseBackupService } from 'src/services/database-backup.service.js';
import { MaintenanceService } from 'src/services/maintenance.service.js';
import { SystemConfigService } from 'src/services/system-config.service.js';
import { getExternalDomain } from 'src/utils/misc.js';

@Injectable()
export class FutoBackupsService {
  constructor(
    private readonly libraryRepository: LibraryRepository,
    private readonly databaseBackupService: DatabaseBackupService,
    private readonly systemConfigService: SystemConfigService,
    @Optional() private readonly maintenanceService: MaintenanceService,
    @Optional() private readonly orchestratorService: OrchestratorService,
  ) {}

  private updateSystemConfig({ server }: SystemConfig) {
    this.orchestratorService.setExternalBaseUrl(getExternalDomain(server));
  }

  private async updateLibraryConfig() {
    const libraries = await this.libraryRepository.getAll();

    this.orchestratorService.setUniversalPhotosIntegration({
      dataPath: StorageCore.getMediaLocation(),
      dataFolders: Object.values(StorageFolder),
      libraries: libraries
        .filter((library) => !library.deletedAt)
        .map(({ id, name, importPaths, exclusionPatterns }) => ({ id, name, importPaths, exclusionPatterns })),
      hooks: {
        getUniversalPhotosDatabaseDumpConfig: () => this.getUniversalPhotosDatabaseDumpConfig(),
        configureUniversalPhotosDatabaseDump: (databaseDump) => this.configureUniversalPhotosDatabaseDump(databaseDump),
        enterMaintenanceRollback: (repositoryId, snapshotId) => this.enterMaintenanceRollback(repositoryId, snapshotId),
      },
    });
  }

  private async getUniversalPhotosDatabaseDumpConfig(): Promise<UniversalPhotosDatabaseDumpConfig> {
    const { backup } = await this.systemConfigService.getAdminConfig();
    return { enabled: backup.database.enabled, keepLastAmount: backup.database.keepLastAmount };
  }

  private async configureUniversalPhotosDatabaseDump(databaseDump: Partial<UniversalPhotosDatabaseDumpConfig>) {
    const config = await this.systemConfigService.getAdminConfig();
    await this.systemConfigService.updateAdminConfig({
      ...config,
      backup: { ...config.backup, database: { ...config.backup.database, ...databaseDump } },
    });
  }

  private enterMaintenanceRollback(repositoryId: string, snapshotId: string) {
    return this.maintenanceService.startMaintenance(
      {
        action: MaintenanceAction.Rollback,
        rollbackRepositoryId: repositoryId,
        rollbackSnapshotId: snapshotId,
      },
      'futo-backups-rollback',
    );
  }

  @OnEvent({ name: 'ConfigInit', workers: [UniversalPhotosWorker.Api] })
  onConfigInit({ newConfig }: ArgOf<'ConfigInit'>) {
    this.updateSystemConfig(newConfig);
    void this.updateLibraryConfig();

    this.orchestratorService.setDatabaseHooks({
      tagName: '',
      dump: (signal) => this.databaseBackupService.createDatabaseBackup('', signal),
      cleanup: () => this.databaseBackupService.cleanupDatabaseBackups(),
      restore: (fileName) => this.databaseBackupService.restoreDatabaseBackup(basename(fileName)),
    });
  }

  @OnEvent({ name: 'ConfigUpdate', workers: [UniversalPhotosWorker.Api], server: true })
  onConfigUpdate({ newConfig }: ArgOf<'ConfigUpdate'>) {
    this.updateSystemConfig(newConfig);
  }

  @OnEvent({ name: 'LibraryCreate', workers: [UniversalPhotosWorker.Api], server: true })
  onLibraryCreate() {
    void this.updateLibraryConfig();
  }

  @OnEvent({ name: 'LibraryUpdate', workers: [UniversalPhotosWorker.Api], server: true })
  onLibraryUpdate() {
    void this.updateLibraryConfig();
  }

  @OnEvent({ name: 'LibraryDelete', workers: [UniversalPhotosWorker.Api], server: true })
  onLibraryDelete() {
    void this.updateLibraryConfig();
  }
}
