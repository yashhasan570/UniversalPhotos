import z from 'zod';
import { UniversalPhotosEnvironmentSchema, LogFormatSchema, LogLevelSchema } from 'src/enum.js';
import { IsIPRange } from 'src/validation.js';

// TODO import from sql-tools once the swagger plugin supports external enums
enum DatabaseSslMode {
  Disable = 'disable',
  Allow = 'allow',
  Prefer = 'prefer',
  Require = 'require',
  VerifyFull = 'verify-full',
}

const DatabaseSslModeSchema = z.enum(DatabaseSslMode).describe('Database SSL mode').meta({ id: 'DatabaseSslMode' });
const absolutePath = z.string().regex(/^\//, 'Must be an absolute path').optional();
/**
Treat certain strings as booleans and coerce them to boolean
Ideal for environment variables that are strings but should be treated as booleans
@docs https://zod.dev/api?id=stringbool
*/
const stringBool = z.stringbool();

const trustedProxiesSchema = z
  .string()
  .optional()
  .transform((s) =>
    s
      ? s
          .split(',')
          .map((x) => x.trim())
          .filter(Boolean)
      : undefined,
  )

  .pipe(z.union([z.undefined(), IsIPRange({ requireCIDR: false })]));

export const EnvSchema = z
  .object({
    UNIVERSALPHOTOS_API_METRICS_PORT: z.coerce.number().int().optional(),
    UNIVERSALPHOTOS_BUILD_DATA: z.string().optional(),
    UNIVERSALPHOTOS_BUILD: z.string().optional(),
    UNIVERSALPHOTOS_BUILD_URL: z.string().optional(),
    UNIVERSALPHOTOS_BUILD_IMAGE: z.string().optional(),
    UNIVERSALPHOTOS_BUILD_IMAGE_URL: z.string().optional(),
    UNIVERSALPHOTOS_CONFIG_FILE: z.string().optional(),
    UNIVERSALPHOTOS_HELMET_FILE: z.string().optional(),
    UNIVERSALPHOTOS_ENV: UniversalPhotosEnvironmentSchema.optional(),
    UNIVERSALPHOTOS_HOST: z.string().optional(),
    UNIVERSALPHOTOS_IGNORE_MOUNT_CHECK_ERRORS: stringBool.optional(),
    UNIVERSALPHOTOS_LOG_LEVEL: LogLevelSchema.optional(),
    UNIVERSALPHOTOS_LOG_FORMAT: LogFormatSchema.optional(),
    UNIVERSALPHOTOS_MEDIA_LOCATION: absolutePath,
    UNIVERSALPHOTOS_MICROSERVICES_METRICS_PORT: z.coerce.number().int().optional(),
    UNIVERSALPHOTOS_ALLOW_EXTERNAL_PLUGINS: stringBool.optional(),
    UNIVERSALPHOTOS_PLUGINS_INSTALL_FOLDER: absolutePath,
    UNIVERSALPHOTOS_PORT: z.coerce.number().int().optional(),
    UNIVERSALPHOTOS_REPOSITORY: z.string().optional(),
    UNIVERSALPHOTOS_REPOSITORY_URL: z.string().optional(),
    UNIVERSALPHOTOS_SOURCE_REF: z.string().optional(),
    UNIVERSALPHOTOS_SOURCE_COMMIT: z.string().optional(),
    UNIVERSALPHOTOS_SOURCE_URL: z.string().optional(),
    UNIVERSALPHOTOS_TELEMETRY_INCLUDE: z.string().optional(),
    UNIVERSALPHOTOS_TELEMETRY_EXCLUDE: z.string().optional(),
    UNIVERSALPHOTOS_THIRD_PARTY_SOURCE_URL: z.string().optional(),
    UNIVERSALPHOTOS_THIRD_PARTY_BUG_FEATURE_URL: z.string().optional(),
    UNIVERSALPHOTOS_THIRD_PARTY_DOCUMENTATION_URL: z.string().optional(),
    UNIVERSALPHOTOS_THIRD_PARTY_SUPPORT_URL: z.string().optional(),
    UNIVERSALPHOTOS_ALLOW_SETUP: stringBool.optional(),
    UNIVERSALPHOTOS_TRUSTED_PROXIES: trustedProxiesSchema,
    UNIVERSALPHOTOS_WORKERS_INCLUDE: z.string().optional(),
    UNIVERSALPHOTOS_WORKERS_EXCLUDE: z.string().optional(),
    DB_DATABASE_NAME: z.string().optional(),
    DB_HOSTNAME: z.string().optional(),
    DB_PASSWORD: z.string().optional(),
    DB_PORT: z.coerce.number().int().optional(),
    DB_SKIP_MIGRATIONS: stringBool.optional(),
    DB_SSL_MODE: DatabaseSslModeSchema.optional(),
    DB_URL: z.string().optional(),
    DB_USERNAME: z.string().optional(),
    DB_VECTOR_EXTENSION: z.enum(['pgvector', 'vectorchord']).optional(),
    NO_COLOR: z.string().optional(),
    REDIS_HOSTNAME: z.string().optional(),
    REDIS_PORT: z.coerce.number().int().optional(),
    REDIS_DBINDEX: z.coerce.number().int().optional(),
    REDIS_USERNAME: z.string().optional(),
    REDIS_PASSWORD: z.string().optional(),
    REDIS_SOCKET: z.string().optional(),
    REDIS_URL: z.string().optional(),
  })
  .meta({ id: 'EnvDto' });
