import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/domain/services/background_worker.service.dart';
import 'package:universal_photos/platform/background_worker_api.g.dart';
import 'package:universal_photos/platform/background_worker_lock_api.g.dart';
import 'package:universal_photos/platform/connectivity_api.g.dart';
import 'package:universal_photos/platform/local_image_api.g.dart';
import 'package:universal_photos/platform/native_sync_api.g.dart';
import 'package:universal_photos/platform/network_api.g.dart';
import 'package:universal_photos/platform/passkey_api.g.dart';
import 'package:universal_photos/platform/permission_api.g.dart';
import 'package:universal_photos/platform/remote_image_api.g.dart';

final backgroundWorkerFgServiceProvider = Provider((_) => BackgroundWorkerFgService(BackgroundWorkerFgHostApi()));

final backgroundWorkerLockServiceProvider = Provider<BackgroundWorkerLockService>(
  (_) => BackgroundWorkerLockService(BackgroundWorkerLockApi()),
);

final nativeSyncApiProvider = Provider<NativeSyncApi>((_) => NativeSyncApi());

final permissionApiProvider = Provider<PermissionApi>((_) => PermissionApi());

final connectivityApiProvider = Provider<ConnectivityApi>((_) => ConnectivityApi());

final passkeyHostApiProvider = Provider<PasskeyHostApi>((_) => PasskeyHostApi());

final localImageApi = LocalImageApi();

final remoteImageApi = RemoteImageApi();

final networkApi = NetworkApi();
