// ignore_for_file: unused-code

import 'package:universal_photos/data/db/main/database.dart';
import 'package:universal_photos/infrastructure/repositories/backup.repository.dart';
import 'package:universal_photos/infrastructure/repositories/local_album.repository.dart';
import 'package:universal_photos/infrastructure/repositories/local_asset.repository.dart';
import 'package:universal_photos/infrastructure/repositories/log.repository.dart';
import 'package:universal_photos/infrastructure/repositories/memory.repository.dart';
import 'package:universal_photos/infrastructure/repositories/partner.repository.dart';
import 'package:universal_photos/infrastructure/repositories/remote_album.repository.dart';
import 'package:universal_photos/infrastructure/repositories/remote_asset.repository.dart';
import 'package:universal_photos/infrastructure/repositories/settings.repository.dart';
import 'package:universal_photos/infrastructure/repositories/storage.repository.dart';
import 'package:universal_photos/infrastructure/repositories/store.repository.dart';
import 'package:universal_photos/infrastructure/repositories/sync_api.repository.dart';
import 'package:universal_photos/infrastructure/repositories/sync_migration.repository.dart';
import 'package:universal_photos/infrastructure/repositories/sync_stream.repository.dart';
import 'package:universal_photos/infrastructure/repositories/trashed_local_asset.repository.dart';
import 'package:universal_photos/infrastructure/repositories/user.repository.dart';
import 'package:universal_photos/infrastructure/repositories/user_api.repository.dart';
import 'package:universal_photos/repositories/album_api_repository.dart';
import 'package:universal_photos/repositories/upload.repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDrift extends Mock implements Drift {}

class MockMemoryRepository extends Mock implements MemoryRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockLogRepository extends Mock implements LogRepository {}

class MockSyncStreamRepository extends Mock implements SyncStreamRepository {}

class MockLocalAlbumRepository extends Mock implements LocalAlbumRepository {}

class MockRemoteAlbumRepository extends Mock implements RemoteAlbumRepository {}

class MockLocalAssetRepository extends Mock implements LocalAssetRepository {}

class MockRemoteAssetRepository extends Mock implements RemoteAssetRepository {}

class MockTrashedLocalAssetRepository extends Mock implements TrashedLocalAssetRepository {}

class MockStorageRepository extends Mock implements StorageRepository {}

class MockBackupRepository extends Mock implements BackupRepository {}

class MockUploadRepository extends Mock implements UploadRepository {}

class MockSyncMigrationRepository extends Mock implements SyncMigrationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockPartnerRepository extends Mock implements PartnerRepository {}

// API Repos
class MockUserApiRepository extends Mock implements UserApiRepository {}

class MockSyncApiRepository extends Mock implements SyncApiRepository {}

class MockAlbumApiRepository extends Mock implements AlbumApiRepository {}
