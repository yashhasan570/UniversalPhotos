import { Permission } from '@universal_photos/sdk';
import { stat } from 'node:fs/promises';
import { app, universal_photosCli, utils } from 'src/utils.js';
import { beforeEach, describe, expect, it } from 'vitest';

describe(`universal_photos login`, () => {
  beforeEach(async () => {
    await utils.resetDatabase();
  });

  it('should require a url', async () => {
    const { stderr, exitCode } = await universal_photosCli(['login']);
    expect(stderr).toBe("error: missing required argument 'url'");
    expect(exitCode).toBe(1);
  });

  it('should require a key', async () => {
    const { stderr, exitCode } = await universal_photosCli(['login', app]);
    expect(stderr).toBe("error: missing required argument 'key'");
    expect(exitCode).toBe(1);
  });

  it('should require a valid key', async () => {
    const { stderr, exitCode } = await universal_photosCli(['login', app, 'universal_photos-is-so-cool']);
    expect(stderr).toContain('Failed to connect to server');
    expect(stderr).toContain('Invalid API key');
    expect(stderr).toContain('401');
    expect(exitCode).toBe(1);
  });

  it('should login and save auth.yml with 600', async () => {
    const admin = await utils.adminSetup();
    const apiKey = await utils.createApiKey(admin.accessToken, [Permission.All]);
    const { stdout, stderr, exitCode } = await universal_photosCli(['login', app, apiKey.secret]);
    expect(stdout.split('\n')).toEqual([
      'Logging in to http://127.0.0.1:2285/api',
      'Logged in as admin@universal_photos.cloud',
      'Wrote auth info to /tmp/universal_photos/auth.yml',
    ]);
    expect(stderr).toBe('');
    expect(exitCode).toBe(0);

    const stats = await stat('/tmp/universal_photos/auth.yml');
    const mode = (stats.mode & 0o777).toString(8);
    expect(mode).toEqual('600');
  });

  it('should login without /api in the url', async () => {
    const admin = await utils.adminSetup();
    const apiKey = await utils.createApiKey(admin.accessToken, [Permission.All]);
    const { stdout, stderr, exitCode } = await universal_photosCli(['login', app.replaceAll('/api', ''), apiKey.secret]);
    expect(stdout.split('\n')).toEqual([
      'Logging in to http://127.0.0.1:2285',
      'Discovered API at http://127.0.0.1:2285/api',
      'Logged in as admin@universal_photos.cloud',
      'Wrote auth info to /tmp/universal_photos/auth.yml',
    ]);
    expect(stderr).toBe('');
    expect(exitCode).toBe(0);
  });
});
