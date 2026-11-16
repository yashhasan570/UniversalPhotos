import { DatabaseConnectionParams } from '@universal_photos/sql-tools';
import { RegisterQueueOptions } from '@nestjs/bullmq';
import { Inject, Injectable, Optional } from '@nestjs/common';
import { QueueOptions } from 'bullmq';
import { Request, Response } from 'express';
import { HelmetOptions } from 'helmet';
import { RedisOptions } from 'ioredis';
import { CLS_ID, ClsModuleOptions } from 'nestjs-cls';
import { OpenTelemetryModuleOptions } from 'nestjs-otel/lib/interfaces/index.js';
import { existsSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { IWorker, citiesFile } from 'src/constants.js';
import { Telemetry } from 'src/decorators.js';
import { EnvSchema } from 'src/dtos/env.dto.js';
import {
  DatabaseExtension,
  UniversalPhotosEnvironment,
  UniversalPhotosHeader,
  UniversalPhotosTelemetry,
  UniversalPhotosWorker,
  LogFormat,
  LogLevel,
  QueueName,
} from 'src/enum.js';
import type { VectorExtension } from 'src/types.js';

export interface EnvData {
  host?: string;
  port: number;
  environment: UniversalPhotosEnvironment;
  configFile?: string;
  logLevel?: LogLevel;
  logFormat?: LogFormat;

  buildMetadata: {
    build?: string;
    buildUrl?: string;
    buildImage?: string;
    buildImageUrl?: string;
    repository?: string;
    repositoryUrl?: string;
    sourceRef?: string;
    sourceCommit?: string;
    sourceUrl?: string;
    thirdPartySourceUrl?: string;
    thirdPartyBugFeatureUrl?: string;
    thirdPartyDocumentationUrl?: string;
    thirdPartySupportUrl?: string;
  };

  bull: {
    config: QueueOptions;
    queues: RegisterQueueOptions[];
  };

  cls: {
    config: ClsModuleOptions;
  };

  helmet: {
    config?: HelmetOptions;
  };

  database: {
    config: DatabaseConnectionParams;
    skipMigrations: boolean;
    vectorExtension?: VectorExtension;
  };

  licensePublicKey: {
    client: string;
    server: string;
  };

  versionCheck: {
    url: string;
  };

  network: {
    trustedProxies: string[];
  };

  otel: OpenTelemetryModuleOptions;

  resourcePaths: {
    lockFile: string;
    geodata: {
      dateFile: string;
      admin1: string;
      admin2: string;
      cities500: string;
      countryInfo: string;
      naturalEarthCountriesPath: string;
    };
    web: {
      root: string;
      indexHtml: string;
    };
    corePlugin: string;
  };

  redis: RedisOptions;

  setup: {
    allow: boolean;
  };

  telemetry: {
    apiPort: number;
    microservicesPort: number;
    metrics: Set<UniversalPhotosTelemetry>;
  };

  storage: {
    ignoreMountCheckErrors: boolean;
    mediaLocation?: string;
  };

  workers: UniversalPhotosWorker[];

  plugins: {
    external: {
      allow: boolean;
      installFolder?: string;
    };
  };

  noColor: boolean;
  nodeVersion?: string;
}

const productionKeys = {
  client:
    'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUF2LzdTMzJjUkE1KysxTm5WRHNDTQpzcFAvakpISU1xT0pYRm5oNE53QTJPcHorUk1mZGNvOTJQc09naCt3d1FlRXYxVTJjMnBqelRpUS8ybHJLcS9rCnpKUmxYd2M0Y1Vlc1FETUpPRitQMnFPTlBiQUprWHZDWFlCVUxpdENJa29Md2ZoU0dOanlJS2FSRGhkL3ROeU4KOCtoTlJabllUMWhTSWo5U0NrS3hVQ096YXRQVjRtQ0RlclMrYkUrZ0VVZVdwOTlWOWF6dkYwRkltblRXcFFTdwpjOHdFWmdPTWg0c3ZoNmFpY3dkemtQQ3dFTGFrMFZhQkgzMUJFVUNRTGI5K0FJdEhBVXRKQ0t4aGI1V2pzMXM5CmJyWGZpMHZycGdjWi82RGFuWTJxZlNQem5PbXZEMkZycmxTMXE0SkpOM1ZvN1d3LzBZeS95TWNtelRXWmhHdWgKVVFJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0tDQo=',
  server:
    'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFvcG5ZRGEwYS9kVTVJZUc3NGlFRQpNd2RBS2pzTmN6TGRDcVJkMVo5eTVUMndqTzdlWUlPZUpUc2wzNTBzUjBwNEtmU1VEU1h2QzlOcERwYzF0T0tsCjVzaEMvQXhwdlFBTENva0Y0anQ4dnJyZDlmQ2FYYzFUcVJiT21uaGl1Z0Q2dmtyME8vRmIzVURpM1UwVHZoUFAKbFBkdlNhd3pMcldaUExmbUhWVnJiclNLbW45SWVTZ3kwN3VrV1RJeUxzY2lOcnZuQnl3c0phUmVEdW9OV1BCSApVL21vMm1YYThtNHdNV2hpWGVoaUlPUXFNdVNVZ1BlQ3NXajhVVngxQ0dsUnpQREEwYlZOUXZlS1hXVnhjRUk2ClVMRWdKeTJGNDlsSDArYVlDbUJmN05FcjZWUTJXQjk1ZXZUS1hLdm4wcUlNN25nRmxjVUF3NmZ1VjFjTkNUSlMKNndJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0tDQo=',
};

const stagingKeys = {
  client:
    'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFuSUNyTm5jbGpPSC9JdTNtWVVaRQp0dGJLV1c3OGRuajl5M0U2ekk3dU1NUndEckdYWFhkTGhkUDFxSWtlZHh0clVVeUpCMWR4R04yQW91S082MlNGCldrbU9PTmNGQlRBWFZTdjhUNVY0S0VwWnFQYWEwaXpNaGxMaE5sRXEvY1ZKdllrWlh1Z2x6b1o3cG1nbzFSdHgKam1iRm5NNzhrYTFRUUJqOVdLaEw2eWpWRUl2MDdVS0lKWHBNTnNuS2g1V083MjZhYmMzSE9udTlETjY5VnFFRQo3dGZrUnRWNmx2U1NzMkFVMngzT255cHA4ek53b0lPTWRibGsyb09aWWROZzY0Y3l2SzJoU0FlU3NVMFRyOVc5Ckgra0Y5QlNCNlk0QXl0QlVkSmkrK2pMSW5HM2Q5cU9ieFVzTlYrN05mRkF5NjJkL0xNR0xSOC9OUFc0U0s3c0MKRlFJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0tDQo=',
  server:
    'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUE3Sy8yd3ZLUS9NdU8ydi9MUm5saAoyUy9zTHhDOGJiTEw1UUlKOGowQ3BVZW40YURlY2dYMUpKUmtGNlpUVUtpNTdTbEhtS3RSM2JOTzJmdTBUUVg5Ck5WMEJzVzllZVB0MmlTMWl4VVFmTzRObjdvTjZzbEtac01qd29RNGtGRGFmM3VHTlZJc0dMb3UxVWRLUVhpeDEKUlRHcXVTb3NZVjNWRlk3Q1hGYTVWaENBL3poVXNsNGFuVXp3eEF6M01jUFVlTXBaenYvbVZiQlRKVzBPSytWZgpWQUJvMXdYMkVBanpBekVHVzQ3Vko4czhnMnQrNHNPaHFBNStMQjBKVzlORUg5QUpweGZzWE4zSzVtM00yNUJVClZXcTlRYStIdHRENnJ0bnAvcUFweXVkWUdwZk9HYTRCUlZTR1MxMURZM0xrb2FlRzYwUEU5NHpoYjduOHpMWkgKelFJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0tDQo=',
};

const WORKER_TYPES = new Set(Object.values(UniversalPhotosWorker));
const TELEMETRY_TYPES = new Set(Object.values(UniversalPhotosTelemetry));

const asSet = <T>(value: string | undefined, defaults: T[]) => {
  const values = (value || '').replaceAll(/\s/g, '').split(',').filter(Boolean);
  return new Set(values.length === 0 ? defaults : (values as T[]));
};

type CspOptions = Exclude<NonNullable<HelmetOptions['contentSecurityPolicy']>, boolean>;
type CspDirectives = NonNullable<CspOptions['directives']>;

export const applyCspHashes = (directives: CspDirectives, manifest: Record<string, string[]>): CspDirectives => {
  const merged = { ...directives };
  for (const [directive, hashes] of Object.entries(manifest)) {
    const sources = merged[directive];
    if (Array.isArray(sources) && !sources.includes(`'unsafe-inline'`)) {
      merged[directive] = [...sources, ...hashes];
    }
  }

  return merged;
};

const resolveHelmetFile = (helmetFile: 'true' | 'false' | string | undefined, webRoot: string) => {
  // default is off
  if (!helmetFile || helmetFile === 'false') {
    return;
  }

  helmetFile = helmetFile === 'true' ? join(import.meta.dirname, '..', '..', 'helmet.json') : helmetFile;

  let config: HelmetOptions;
  try {
    config = JSON.parse(readFileSync(helmetFile).toString()) as HelmetOptions;
  } catch (error) {
    throw new Error(`Failed to read helmet file: ${helmetFile}`, { cause: error });
  }

  const contentSecurityPolicy = config.contentSecurityPolicy;
  if (!contentSecurityPolicy || typeof contentSecurityPolicy === 'boolean' || !contentSecurityPolicy.directives) {
    return config;
  }

  // merge with csp build-time metadata
  const manifestFile = join(webRoot, '.csp.json');

  if (!existsSync(join(webRoot, 'index.html')) || !existsSync(manifestFile)) {
    return config;
  }

  let manifest: Record<string, string[]>;
  try {
    manifest = JSON.parse(readFileSync(manifestFile).toString()) as Record<string, string[]>;
  } catch (error) {
    throw new Error(`Failed to read CSP manifest: ${manifestFile}`, { cause: error });
  }

  const directives = applyCspHashes(contentSecurityPolicy.directives, manifest);

  return { ...config, contentSecurityPolicy: { ...contentSecurityPolicy, directives } };
};

const getEnv = (): EnvData => {
  const parseResult = EnvSchema.safeParse(process.env);
  if (!parseResult.success) {
    const messages = ['Invalid environment variables: '];
    for (const issue of parseResult.error.issues) {
      const path = issue.path.join('.');
      messages.push(`  - [${path}] ${issue.message}`);
    }
    throw new Error(messages.join('\n'));
  }
  const dto = parseResult.data;

  const includedWorkers = asSet(dto.UNIVERSALPHOTOS_WORKERS_INCLUDE, [UniversalPhotosWorker.Api, UniversalPhotosWorker.Microservices]);
  const excludedWorkers = asSet(dto.UNIVERSALPHOTOS_WORKERS_EXCLUDE, []);
  const workers = [...includedWorkers.difference(excludedWorkers)];
  for (const worker of workers) {
    if (!WORKER_TYPES.has(worker)) {
      throw new Error(`Invalid worker(s) found: ${workers.join(',')}`);
    }
  }

  const environment = dto.UNIVERSALPHOTOS_ENV || UniversalPhotosEnvironment.Production;
  const isProd = environment === UniversalPhotosEnvironment.Production;
  const buildFolder = dto.UNIVERSALPHOTOS_BUILD_DATA || '/build';
  const folders = {
    geodata: join(buildFolder, 'geodata'),
    web: join(buildFolder, 'www'),
  };

  let redisConfig = {
    host: dto.REDIS_HOSTNAME || 'redis',
    port: dto.REDIS_PORT || 6379,
    db: dto.REDIS_DBINDEX || 0,
    username: dto.REDIS_USERNAME || undefined,
    password: dto.REDIS_PASSWORD || undefined,
    path: dto.REDIS_SOCKET || undefined,
  };

  const redisUrl = dto.REDIS_URL;
  if (redisUrl && redisUrl.startsWith('ioredis://')) {
    try {
      redisConfig = JSON.parse(Buffer.from(redisUrl.slice(10), 'base64').toString());
    } catch (error) {
      throw new Error('Failed to decode redis options', { cause: error });
    }
  }

  const includedTelemetries =
    dto.UNIVERSALPHOTOS_TELEMETRY_INCLUDE === 'all'
      ? new Set(Object.values(UniversalPhotosTelemetry))
      : asSet<UniversalPhotosTelemetry>(dto.UNIVERSALPHOTOS_TELEMETRY_INCLUDE, []);

  const excludedTelemetries = asSet<UniversalPhotosTelemetry>(dto.UNIVERSALPHOTOS_TELEMETRY_EXCLUDE, []);
  const telemetries = includedTelemetries.difference(excludedTelemetries);
  for (const telemetry of telemetries) {
    if (!TELEMETRY_TYPES.has(telemetry)) {
      throw new Error(`Invalid telemetry found: ${telemetry}`);
    }
  }

  const databaseConnection: DatabaseConnectionParams = dto.DB_URL
    ? { connectionType: 'url', url: dto.DB_URL }
    : {
        connectionType: 'parts',
        host: dto.DB_HOSTNAME || 'database',
        port: dto.DB_PORT || 5432,
        username: dto.DB_USERNAME || 'postgres',
        password: dto.DB_PASSWORD || 'postgres',
        database: dto.DB_DATABASE_NAME || 'universal_photos',
        ssl: dto.DB_SSL_MODE || undefined,
      };

  let vectorExtension: VectorExtension | undefined;
  if (dto.DB_VECTOR_EXTENSION) {
    switch (dto.DB_VECTOR_EXTENSION) {
      case 'pgvector': {
        vectorExtension = DatabaseExtension.Vector;
        break;
      }
      case 'vectorchord': {
        vectorExtension = DatabaseExtension.VectorChord;
        break;
      }
    }
  }

  return {
    host: dto.UNIVERSALPHOTOS_HOST,
    port: dto.UNIVERSALPHOTOS_PORT || 2283,
    environment,
    configFile: dto.UNIVERSALPHOTOS_CONFIG_FILE,
    logLevel: dto.UNIVERSALPHOTOS_LOG_LEVEL,
    logFormat: dto.UNIVERSALPHOTOS_LOG_FORMAT || LogFormat.Console,

    buildMetadata: {
      build: dto.UNIVERSALPHOTOS_BUILD,
      buildUrl: dto.UNIVERSALPHOTOS_BUILD_URL,
      buildImage: dto.UNIVERSALPHOTOS_BUILD_IMAGE,
      buildImageUrl: dto.UNIVERSALPHOTOS_BUILD_IMAGE_URL,
      repository: dto.UNIVERSALPHOTOS_REPOSITORY,
      repositoryUrl: dto.UNIVERSALPHOTOS_REPOSITORY_URL,
      sourceRef: dto.UNIVERSALPHOTOS_SOURCE_REF,
      sourceCommit: dto.UNIVERSALPHOTOS_SOURCE_COMMIT,
      sourceUrl: dto.UNIVERSALPHOTOS_SOURCE_URL,
      thirdPartySourceUrl: dto.UNIVERSALPHOTOS_THIRD_PARTY_SOURCE_URL,
      thirdPartyBugFeatureUrl: dto.UNIVERSALPHOTOS_THIRD_PARTY_BUG_FEATURE_URL,
      thirdPartyDocumentationUrl: dto.UNIVERSALPHOTOS_THIRD_PARTY_DOCUMENTATION_URL,
      thirdPartySupportUrl: dto.UNIVERSALPHOTOS_THIRD_PARTY_SUPPORT_URL,
    },

    bull: {
      config: {
        prefix: 'universal_photos_bull',
        connection: { ...redisConfig },
        defaultJobOptions: {
          attempts: 1,
          removeOnComplete: true,
          removeOnFail: false,
        },
      },
      queues: Object.values(QueueName).map((name) => ({ name })),
    },

    cls: {
      config: {
        middleware: {
          mount: true,
          generateId: true,
          setup: (cls, req: Request, res: Response) => {
            const cid = req.header(UniversalPhotosHeader.CorrelationId) || cls.get(CLS_ID);
            cls.set(CLS_ID, cid);
            res.header(UniversalPhotosHeader.CorrelationId, cid);
          },
        },
      },
    },

    database: {
      config: databaseConnection,
      skipMigrations: dto.DB_SKIP_MIGRATIONS ?? false,
      vectorExtension,
    },

    helmet: {
      config: resolveHelmetFile(dto.UNIVERSALPHOTOS_HELMET_FILE, folders.web),
    },

    licensePublicKey: isProd ? productionKeys : stagingKeys,

    versionCheck: {
      url: isProd ? 'https://version.universal_photos.cloud/version' : 'https://version.dev.universal_photos.cloud/version',
    },

    network: {
      trustedProxies: dto.UNIVERSALPHOTOS_TRUSTED_PROXIES ?? ['linklocal', 'uniquelocal'],
    },

    otel: {
      metrics: {
        hostMetrics: telemetries.has(UniversalPhotosTelemetry.Host),
      },
    },

    redis: redisConfig,

    resourcePaths: {
      lockFile: join(buildFolder, 'build-lock.json'),
      geodata: {
        dateFile: join(folders.geodata, 'geodata-date.txt'),
        admin1: join(folders.geodata, 'admin1CodesASCII.txt'),
        admin2: join(folders.geodata, 'admin2Codes.txt'),
        cities500: join(folders.geodata, citiesFile),
        countryInfo: join(folders.geodata, 'countryInfo.txt'),
        naturalEarthCountriesPath: join(folders.geodata, 'ne_10m_admin_0_countries.geojson'),
      },
      web: {
        root: folders.web,
        indexHtml: join(folders.web, 'index.html'),
      },
      corePlugin: join(buildFolder, 'plugins', 'universal_photos-plugin-core'),
    },

    setup: {
      allow: dto.UNIVERSALPHOTOS_ALLOW_SETUP ?? true,
    },

    storage: {
      ignoreMountCheckErrors: !!dto.UNIVERSALPHOTOS_IGNORE_MOUNT_CHECK_ERRORS,
      mediaLocation: dto.UNIVERSALPHOTOS_MEDIA_LOCATION,
    },

    telemetry: {
      apiPort: dto.UNIVERSALPHOTOS_API_METRICS_PORT || 8081,
      microservicesPort: dto.UNIVERSALPHOTOS_MICROSERVICES_METRICS_PORT || 8082,
      metrics: telemetries,
    },

    workers,

    plugins: {
      external: {
        allow: dto.UNIVERSALPHOTOS_ALLOW_EXTERNAL_PLUGINS ?? false,
        installFolder: dto.UNIVERSALPHOTOS_PLUGINS_INSTALL_FOLDER,
      },
    },

    noColor: !!dto.NO_COLOR,
  };
};

let cached: EnvData | undefined;

@Injectable()
@Telemetry({ enabled: false })
export class ConfigRepository {
  constructor(@Inject(IWorker) @Optional() private worker?: UniversalPhotosWorker) {}

  getEnv() {
    if (!cached) {
      cached = getEnv();
    }

    return cached;
  }

  isDev() {
    return this.getEnv().environment === UniversalPhotosEnvironment.Development;
  }

  isProduction() {
    return this.getEnv().environment === UniversalPhotosEnvironment.Production;
  }

  getWorker() {
    return this.worker;
  }
}

export const clearEnvCache = () => (cached = undefined);
