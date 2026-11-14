import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/domain/models/asset/base_asset.model.dart';
import 'package:universal_photos/providers/infrastructure/asset.provider.dart';

class StackChildrenNotifier extends AutoDisposeFamilyAsyncNotifier<List<RemoteAsset>, BaseAsset> {
  @override
  Future<List<RemoteAsset>> build(BaseAsset asset) {
    if (asset is! RemoteAsset || asset.stackId == null) {
      return Future.value(const []);
    }

    return ref.watch(assetServiceProvider).getStack(asset);
  }
}

final stackChildrenNotifier = AsyncNotifierProvider.autoDispose
    .family<StackChildrenNotifier, List<RemoteAsset>, BaseAsset>(StackChildrenNotifier.new);
