#! /usr/bin/env node
import { AssetVisibility } from '@universalphotos/sdk';
import { Command, Option } from 'commander';
import os from 'node:os';
import path from 'node:path';
import { upload } from 'src/commands/asset.js';
import { login, logout } from 'src/commands/auth.js';
import { serverInfo } from 'src/commands/server-info.js';
import { version } from '../package.json';

const defaultConfigDirectory = path.join(os.homedir(), '.config/universalphotos/');
const defaultConcurrency = Math.max(1, os.cpus().length - 1);

const program = new Command()
  .name('universalphotos')
  .version(version)
  .description('Command line interface for UniversalPhotos')
  .addOption(
    new Option('-d, --config-directory <directory>', 'Configuration directory where auth.yml will be stored')
      .env('UNIVERSALPHOTOS_CONFIG_DIR')
      .default(defaultConfigDirectory),
  )
  .addOption(new Option('-u, --url [url]', 'UniversalPhotos server URL').env('UNIVERSALPHOTOS_INSTANCE_URL'))
  .addOption(new Option('-k, --key [key]', 'UniversalPhotos API key').env('UNIVERSALPHOTOS_API_KEY'));

program
  .command('login')
  .alias('login-key')
  .description('Login using an API key')
  .argument('url', 'UniversalPhotos server URL')
  .argument('key', 'UniversalPhotos API key')
  .action((url, key) => login(url, key, program.opts()));

program
  .command('logout')
  .description('Remove stored credentials')
  .action(() => logout(program.opts()));

program
  .command('server-info')
  .description('Display server information')
  .action(() => serverInfo(program.opts()));

program
  .command('upload')
  .description('Upload assets')
  .usage('[paths...] [options]')
  .addOption(new Option('-r, --recursive', 'Recursive').env('UNIVERSALPHOTOS_RECURSIVE').default(false))
  .addOption(new Option('-i, --ignore <pattern>', 'Pattern to ignore').env('UNIVERSALPHOTOS_IGNORE_PATHS'))
  .addOption(new Option('--skip-hash', "Don't hash files before upload").env('UNIVERSALPHOTOS_SKIP_HASH').default(false))
  .addOption(new Option('-H, --include-hidden', 'Include hidden folders').env('UNIVERSALPHOTOS_INCLUDE_HIDDEN').default(false))
  .addOption(
    new Option('-a, --album', 'Automatically create albums based on folder name')
      .env('UNIVERSALPHOTOS_AUTO_CREATE_ALBUM')
      .default(false),
  )
  .addOption(
    new Option('-A, --album-name <name>', 'Add all assets to specified album')
      .env('UNIVERSALPHOTOS_ALBUM_NAME')
      .conflicts('album'),
  )
  .addOption(
    new Option('--visibility <visibility>', 'Set the visibility of uploaded assets')
      .choices(Object.values(AssetVisibility))
      .env('UNIVERSALPHOTOS_VISIBILITY'),
  )
  .addOption(
    new Option('-n, --dry-run', "Don't perform any actions, just show what will be done")
      .env('UNIVERSALPHOTOS_DRY_RUN')
      .default(false)
      .conflicts('skipHash'),
  )
  .addOption(
    new Option('-c, --concurrency <number>', 'Number of assets to upload at the same time')
      .env('UNIVERSALPHOTOS_UPLOAD_CONCURRENCY')
      .default(defaultConcurrency),
  )
  .addOption(
    new Option('-j, --json-output', 'Output detailed information in json format')
      .env('UNIVERSALPHOTOS_JSON_OUTPUT')
      .default(false),
  )
  .addOption(new Option('--delete', 'Delete local assets after upload').env('UNIVERSALPHOTOS_DELETE_ASSETS'))
  .addOption(
    new Option('--delete-duplicates', 'Delete local assets that are duplicates (already exist on server)').env(
      'UNIVERSALPHOTOS_DELETE_DUPLICATES',
    ),
  )
  .addOption(new Option('--no-progress', 'Hide progress bars').env('UNIVERSALPHOTOS_PROGRESS_BAR').default(true))
  .addOption(
    new Option('--watch', 'Watch for changes and upload automatically')
      .env('UNIVERSALPHOTOS_WATCH_CHANGES')
      .default(false)
      .implies({ progress: false }),
  )
  .argument('[paths...]', 'One or more paths to assets to be uploaded')
  .action((paths, options) => upload(paths, program.opts(), options));

program.parse(process.argv);
