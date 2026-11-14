import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/domain/models/asset/base_asset.model.dart';
import 'package:universal_photos/presentation/widgets/timeline/timeline.widget.dart';
import 'package:universal_photos/providers/infrastructure/timeline.provider.dart';
import 'package:universal_photos/providers/timeline/multiselect.provider.dart';

@RoutePage()
class AssetSelectionTimelinePage extends StatelessWidget {
  final Set<BaseAsset> lockedSelectionAssets;
  const AssetSelectionTimelinePage({super.key, this.lockedSelectionAssets = const {}});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        multiSelectProvider.overrideWith(
          () => MultiSelectNotifier(
            MultiSelectState(selectedAssets: {}, lockedSelectionAssets: lockedSelectionAssets, forceEnable: true),
          ),
        ),
        timelineServiceProvider.overrideWith((ref) {
          final timelineUsers = ref.watch(timelineUsersProvider).valueOrNull ?? [];
          final timelineService = ref.watch(timelineFactoryProvider).main(timelineUsers);
          ref.onDispose(timelineService.dispose);
          return timelineService;
        }),
      ],
      child: const Timeline(showStorageIndicator: true),
    );
  }
}
