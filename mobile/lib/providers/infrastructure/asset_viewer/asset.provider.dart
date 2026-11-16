import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos_mobile/domain/models/asset/base_asset.model.dart';
import 'package:universal_photos_mobile/domain/models/exif.model.dart';
import 'package:universal_photos_mobile/providers/infrastructure/asset.provider.dart';

final assetExifProvider = StreamProvider.autoDispose.family<ExifInfo?, BaseAsset>((ref, asset) {
  return ref.watch(assetServiceProvider).watchExif(asset);
});
