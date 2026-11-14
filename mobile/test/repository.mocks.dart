import 'package:universal_photos/data/server/tag.dart';
import 'package:universal_photos/infrastructure/repositories/remote_exif.repository.dart';
import 'package:universal_photos/repositories/asset_api.repository.dart';
import 'package:universal_photos/repositories/asset_media.repository.dart';
import 'package:universal_photos/repositories/auth.repository.dart';
import 'package:universal_photos/repositories/auth_api.repository.dart';
import 'package:universal_photos/repositories/download.repository.dart';
import 'package:universal_photos/repositories/permission.repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAssetApiRepository extends Mock implements AssetApiRepository {}

class MockAssetMediaRepository extends Mock implements AssetMediaRepository {}

class MockPermissionRepository extends Mock implements DevicePermissionRepository {}

class MockAuthApiRepository extends Mock implements AuthApiRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTagApiRepository extends Mock implements TagApiRepository {}

class MockDownloadRepository extends Mock implements DownloadRepository {}

class MockRemoteExifRepository extends Mock implements RemoteExifRepository {}
