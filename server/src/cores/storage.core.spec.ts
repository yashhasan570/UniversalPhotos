import { vitest } from 'vitest';
import { StorageCore } from 'src/cores/storage.core.js';

vitest.mock('src/constants', () => ({
  IWorker: 'IWorker',
}));

describe('StorageCore', () => {
  describe('isUniversalPhotosPath', () => {
    beforeAll(() => {
      StorageCore.setMediaLocation('/photos');
    });

    it('should return true for APP_MEDIA_LOCATION path', () => {
      const universalphotosPath = '/photos';
      expect(StorageCore.isUniversalPhotosPath(universalphotosPath)).toBe(true);
    });

    it('should return true for paths within the APP_MEDIA_LOCATION', () => {
      const universalphotosPath = '/photos/new/';
      expect(StorageCore.isUniversalPhotosPath(universalphotosPath)).toBe(true);
    });

    it('should return false for paths outside the APP_MEDIA_LOCATION and same starts', () => {
      const nonUniversalPhotosPath = '/photos_new';
      expect(StorageCore.isUniversalPhotosPath(nonUniversalPhotosPath)).toBe(false);
    });

    it('should return false for paths outside the APP_MEDIA_LOCATION', () => {
      const nonUniversalPhotosPath = '/some/other/path';
      expect(StorageCore.isUniversalPhotosPath(nonUniversalPhotosPath)).toBe(false);
    });
  });
});
