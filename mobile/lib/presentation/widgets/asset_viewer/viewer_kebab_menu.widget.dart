import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/constants/enums.dart';
import 'package:universal_photos/domain/models/asset/base_asset.model.dart';
import 'package:universal_photos/extensions/build_context_extensions.dart';
import 'package:universal_photos/providers/asset_viewer/asset_viewer.provider.dart';
import 'package:universal_photos/providers/cast.provider.dart';
import 'package:universal_photos/providers/infrastructure/current_album.provider.dart';
import 'package:universal_photos/providers/infrastructure/setting.provider.dart';
import 'package:universal_photos/providers/infrastructure/timeline.provider.dart';
import 'package:universal_photos/providers/routes.provider.dart';
import 'package:universal_photos/providers/user.provider.dart';
import 'package:universal_photos/utils/action_button.utils.dart';
import 'package:universalphotos_ui/universalphotos_ui.dart';

class ViewerKebabMenu extends ConsumerWidget {
  const ViewerKebabMenu({super.key, this.originalTheme});

  final ThemeData? originalTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetViewerProvider.select((s) => s.currentAsset));
    if (asset == null) {
      return const SizedBox.shrink();
    }

    final user = ref.watch(currentUserProvider);
    final isOwner = asset is RemoteAsset && asset.ownerId == user?.id;
    final isCasting = ref.watch(castProvider.select((c) => c.isCasting));
    final timelineOrigin = ref.watch(timelineServiceProvider).origin;
    final isInLockedView = ref.watch(inLockedViewProvider);
    final currentAlbum = ref.watch(currentRemoteAlbumProvider);
    final isArchived = asset is RemoteAsset && asset.visibility == AssetVisibility.archive;
    final advancedTroubleshooting = ref.watch(settingsProvider.notifier).get(.advancedTroubleshooting);

    final actionContext = ActionButtonContext(
      asset: asset,
      isOwner: isOwner,
      isArchived: isArchived,
      isStacked: asset is RemoteAsset && asset.stackId != null,
      isInLockedView: isInLockedView,
      currentAlbum: currentAlbum,
      advancedTroubleshooting: advancedTroubleshooting,
      source: ActionSource.viewer,
      isCasting: isCasting,
      timelineOrigin: timelineOrigin,
    );

    final menuChildren = ActionButtonBuilder.buildViewerKebabMenu(actionContext, context);

    return UniversalPhotosMenu(
      consumeOutsideTap: true,
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(context.themeData.scaffoldBackgroundColor),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.grey),
        elevation: const WidgetStatePropertyAll(4),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 6)),
      ),
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 150),
          child: Theme(
            data: originalTheme ?? context.themeData,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuChildren,
            ),
          ),
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () => controller.isOpen ? controller.close() : controller.open(),
        );
      },
    );
  }
}
