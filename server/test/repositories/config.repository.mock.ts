import { Mocked, vitest } from 'vitest';
import { DatabaseExtension, UniversalPhotosEnvironment, UniversalPhotosWorker, LogFormat } from 'src/enum.js';
import { ConfigRepository, EnvData } from 'src/repositories/config.repository.js';
import type { RepositoryInterface } from 'src/types.js';

export const envData: EnvData = {
  port: 2283,
  environment: UniversalPhotosEnvironment.Production,
  logFormat: LogFormat.Console,

  buildMetadata: {},
  bull: {
    config: {
      connection: {},
      prefix: 'universalphotos_bull',
    },
    queues: [{ name: 'queue-1' }],
  },

  cls: {
    config: {},
  },

  database: {
    config: {
      connectionType: 'parts',
      database: 'universalphotos',
      host: 'database',
      port: 5432,
      username: 'postgres',
      password: 'postgres',
    },
    skipMigrations: false,
    vectorExtension: DatabaseExtension.VectorChord,
  },

  helmet: {
    config: {},
  },

  licensePublicKey: {
    client: 'client-public-key',
    server: 'server-public-key',
  },

  versionCheck: {
    url: 'https://version./version',
  },

  network: {
    trustedProxies: [],
  },

  otel: {
    metrics: {
      hostMetrics: false,
    },
  },

  redis: {
    host: 'redis',
    port: 6379,
    db: 0,
  },

  resourcePaths: {
    lockFile: 'build-lock.json',
    geodata: {
      dateFile: '/build/geodata/geodata-date.txt',
      admin1: '/build/geodata/admin1CodesASCII.txt',
      admin2: '/build/geodata/admin2Codes.txt',
      cities500: '/build/geodata/cities500.txt',
      countryInfo: '/build/geodata/countryInfo.txt',
      naturalEarthCountriesPath: 'build/ne_10m_admin_0_countries.geojson',
    },
    web: {
      root: '/build/www',
      indexHtml: '/build/www/index.html',
    },
    corePlugin: '/build/plugins/universalphotos-plugin-core',
  },

  setup: {
    allow: true,
  },

  storage: {
    ignoreMountCheckErrors: false,
  },

  telemetry: {
    apiPort: 8081,
    microservicesPort: 8082,
    metrics: new Set(),
  },

  workers: [UniversalPhotosWorker.Api, UniversalPhotosWorker.Microservices],

  plugins: {
    external: {
      allow: true,
      installFolder: '/app/data/plugins',
    },
  },

  noColor: false,
};

export const mockEnvData = (config: Partial<EnvData>) => ({ ...envData, ...config });
export const newConfigRepositoryMock = (): Mocked<RepositoryInterface<ConfigRepository>> => {
  return {
    getEnv: vitest.fn().mockReturnValue(mockEnvData({})),
    getWorker: vitest.fn().mockReturnValue(UniversalPhotosWorker.Api),
    isDev: vitest.fn().mockReturnValue(false),
    isProduction: vitest.fn().mockReturnValue(true),
  };
};
