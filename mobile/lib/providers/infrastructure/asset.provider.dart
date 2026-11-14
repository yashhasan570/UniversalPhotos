import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/domain/services/asset.service.dart';
import 'package:universal_photos/providers/infrastructure/db.provider.dart';
import 'package:universal_photos/providers/user.provider.dart';
import 'package:universal_photos/repositories/asset_api.repository.dart';
import 'package:universal_photos/repositories/asset_media.repository.dart';

final assetServiceProvider = Provider((ref) {
  final db = ref.watch(driftProvider);
  return AssetService(
    remoteRepository: db.remoteAssetRepository,
    exifRepository: db.remoteExifRepository,
    localRepository: db.localAssetRepository,
    apiRepository: ref.watch(assetApiRepositoryProvider),
    mediaRepository: ref.watch(assetMediaRepositoryProvider),
    trashedLocalRepository: db.trashedLocalAssetRepository,
  );
});

final placesProvider = FutureProvider<List<(String, String)>>((ref) {
  final assetService = ref.watch(assetServiceProvider);
  final auth = ref.watch(currentUserProvider);

  if (auth == null) {
    return Future.value(const []);
  }

  return assetService.getPlaces(auth.id);
});
