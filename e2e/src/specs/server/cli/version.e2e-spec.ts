import { readFileSync } from 'node:fs';
import { universal_photosCli } from 'src/utils.js';
import { describe, expect, it } from 'vitest';

const pkg = JSON.parse(readFileSync('../packages/cli/package.json', 'utf8'));

describe(`universal_photos --version`, () => {
  describe('universal_photos --version', () => {
    it('should print the cli version', async () => {
      const { stdout, stderr, exitCode } = await universal_photosCli(['--version']);
      expect(stdout).toEqual(pkg.version);
      expect(stderr).toEqual('');
      expect(exitCode).toBe(0);
    });
  });

  describe('universal_photos -V', () => {
    it('should print the cli version', async () => {
      const { stdout, stderr, exitCode } = await universal_photosCli(['-V']);
      expect(stdout).toEqual(pkg.version);
      expect(stderr).toEqual('');
      expect(exitCode).toBe(0);
    });
  });
});
