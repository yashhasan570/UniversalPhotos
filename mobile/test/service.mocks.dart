// ignore_for_file: unused-code

import 'package:universal_photos/domain/services/asset.service.dart';
import 'package:universal_photos/domain/services/background_worker.service.dart';
import 'package:universal_photos/domain/services/partner.service.dart';
import 'package:universal_photos/domain/services/remote_album.service.dart';
import 'package:universal_photos/domain/services/store.service.dart';
import 'package:universal_photos/domain/services/user.service.dart';
import 'package:universal_photos/domain/utils/background_sync.dart';
import 'package:universal_photos/platform/native_sync_api.g.dart';
import 'package:universal_photos/services/api.service.dart';
import 'package:universal_photos/services/app_settings.service.dart';
import 'package:universal_photos/services/auth.service.dart';
import 'package:universal_photos/services/background_upload.service.dart';
import 'package:universal_photos/services/cleanup.service.dart';
import 'package:universal_photos/services/foreground_upload.service.dart';
import 'package:universal_photos/services/gcast.service.dart';
import 'package:universal_photos/services/network.service.dart';
import 'package:universal_photos/services/secure_storage.service.dart';
import 'package:universal_photos/services/server_info.service.dart';
import 'package:universal_photos/services/toast.service.dart';
import 'package:universal_photos/services/widget.service.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

class MockNetworkService extends Mock implements NetworkService {}

class MockAppSettingService extends Mock implements AppSettingsService {}

class MockStoreService extends Mock implements StoreService {}

class MockNativeSyncApi extends Mock implements NativeSyncApi {}

class MockAppSettingsService extends Mock implements AppSettingsService {}

class MockPartnerService extends Mock implements PartnerService {}

class MockAssetService extends Mock implements AssetService {}

class MockUserService extends Mock implements UserService {}

class MockRemoteAlbumService extends Mock implements RemoteAlbumService {}

class MockGCastService extends Mock implements GCastService {}

class MockForegroundUploadService extends Mock implements ForegroundUploadService {}

class MockServerInfoService extends Mock implements ServerInfoService {}

class MockCleanupService extends Mock implements CleanupService {}

class MockBackgroundSyncManager extends Mock implements BackgroundSyncManager {}

class MockToastService extends Mock implements ToastService {}

class MockAuthService extends Mock implements AuthService {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockWidgetService extends Mock implements WidgetService {}

class MockBackgroundUploadService extends Mock implements BackgroundUploadService {}

class MockBackgroundWorkerLockService extends Mock implements BackgroundWorkerLockService {}

class MockBackgroundWorkerFgService extends Mock implements BackgroundWorkerFgService {}
