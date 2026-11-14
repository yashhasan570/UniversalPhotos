import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/domain/models/album/album.model.dart';
import 'package:universal_photos/domain/models/asset/base_asset.model.dart';
import 'package:universal_photos/generated/translations.g.dart';
import 'package:universal_photos/presentation/actions/action.widget.dart';
import 'package:universal_photos/presentation/actions/archive.action.dart';
import 'package:universal_photos/presentation/actions/asset_debug.action.dart';
import 'package:universal_photos/presentation/actions/delete.action.dart';
import 'package:universal_photos/presentation/actions/download.action.dart';
import 'package:universal_photos/presentation/actions/edit_datetime.action.dart';
import 'package:universal_photos/presentation/actions/edit_location.action.dart';
import 'package:universal_photos/presentation/actions/favorite.action.dart';
import 'package:universal_photos/presentation/actions/lock.action.dart';
import 'package:universal_photos/presentation/actions/share.action.dart';
import 'package:universal_photos/presentation/actions/share_link.action.dart';
import 'package:universal_photos/presentation/actions/stack.action.dart';
import 'package:universal_photos/presentation/widgets/album/album_selector.widget.dart';
import 'package:universal_photos/presentation/widgets/bottom_sheet/base_bottom_sheet.widget.dart';
import 'package:universal_photos/providers/infrastructure/album.provider.dart';
import 'package:universal_photos/providers/timeline/multiselect.provider.dart';
import 'package:universal_photos/widgets/common/universalphotos_toast.dart';

class FavoriteBottomSheet extends ConsumerWidget {
  const FavoriteBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multiselect = ref.watch(multiSelectProvider);

    Future<void> addAssetsToAlbum(RemoteAlbum album) async {
      final selectedAssets = multiselect.selectedAssets;
      if (selectedAssets.isEmpty) {
        return;
      }

      final remoteAssets = selectedAssets.whereType<RemoteAsset>();
      final result = await ref
          .read(remoteAlbumProvider.notifier)
          .addAssets(album.id, remoteAssets.map((e) => e.id).toList());
      if (!context.mounted) {
        return;
      }

      if (selectedAssets.length != remoteAssets.length) {
        UniversalPhotosToast.show(context: context, msg: context.t.add_to_album_bottom_sheet_some_local_assets);
      }

      // Only report the failure when nothing was added; if some succeeded we show "added".
      if (result.added > 0) {
        UniversalPhotosToast.show(
          context: context,
          msg: context.t.add_to_album_bottom_sheet_added(album: album.name),
        );
      } else if (result.failed > 0) {
        UniversalPhotosToast.show(
          context: context,
          msg: context.t.assets_cannot_be_added_to_album_count(count: result.failed),
          toastType: ToastType.error,
        );
      } else {
        UniversalPhotosToast.show(
          context: context,
          msg: context.t.add_to_album_bottom_sheet_already_exists(album: album.name),
        );
      }

      ref.read(multiSelectProvider.notifier).reset();
    }

    return BaseBottomSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.7,
      shouldCloseOnMinExtent: false,
      actions: const <ActionColumnButton>[
        .new(action: AssetDebugAction(source: .timeline)),
        .new(action: ShareAction(source: .timeline)),
        .new(action: ShareLinkAction(source: .timeline)),
        .new(action: FavoriteAction(source: .timeline)),
        .new(action: ArchiveAction(source: .timeline)),
        .new(action: DownloadAction(source: .timeline)),
        .new(action: DeleteAction(source: .timeline)),
        .new(action: EditDateTimeAction(source: .timeline)),
        .new(action: EditLocationAction(source: .timeline)),
        .new(action: LockAction(source: .timeline)),
        .new(action: StackAction(source: .timeline)),
        .new(action: CleanupLocalAction(source: .timeline)),
      ],
      slivers: multiselect.hasRemote
          ? [const AddToAlbumHeader(), AlbumSelector(onAlbumSelected: addAssetsToAlbum)]
          : [],
    );
  }
}
