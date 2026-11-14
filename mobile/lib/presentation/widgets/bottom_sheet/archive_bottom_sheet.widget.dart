import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/constants/enums.dart';
import 'package:universal_photos/domain/models/album/album.model.dart';
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
import 'package:universal_photos/providers/infrastructure/action.provider.dart';
import 'package:universal_photos/widgets/common/universalphotos_toast.dart';

class ArchiveBottomSheet extends ConsumerStatefulWidget {
  const ArchiveBottomSheet({super.key});

  @override
  ConsumerState<ArchiveBottomSheet> createState() => _ArchiveBottomSheetState();
}

class _ArchiveBottomSheetState extends ConsumerState<ArchiveBottomSheet> {
  late final DraggableScrollableController sheetController;

  @override
  void initState() {
    super.initState();
    sheetController = DraggableScrollableController();
  }

  @override
  void dispose() {
    sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> addToAlbum(RemoteAlbum album) async {
      final result = await ref.read(actionProvider.notifier).addToAlbum(ActionSource.timeline, album);

      if (!context.mounted) {
        return;
      }

      if (!result.success) {
        UniversalPhotosToast.show(context: context, msg: context.t.scaffold_body_error_occurred, toastType: ToastType.error);
        return;
      }

      UniversalPhotosToast.show(
        context: context,
        msg: result.count == 0
            ? context.t.add_to_album_bottom_sheet_already_exists(album: album.name)
            : context.t.add_to_album_bottom_sheet_added(album: album.name),
      );
    }

    Future<void> onKeyboardExpand() {
      return sheetController.animateTo(0.85, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }

    return BaseBottomSheet(
      controller: sheetController,
      initialChildSize: 0.25,
      maxChildSize: 0.85,
      shouldCloseOnMinExtent: false,
      actions: const <ActionColumnButton>[
        .new(action: AssetDebugAction(source: .timeline)),
        .new(action: ShareAction(source: .timeline)),
        .new(action: ShareLinkAction(source: .timeline)),
        .new(action: ArchiveAction(source: .timeline)),
        .new(action: FavoriteAction(source: .timeline)),
        .new(action: DownloadAction(source: .timeline)),
        .new(action: DeleteAction(source: .timeline)),
        .new(action: EditDateTimeAction(source: .timeline)),
        .new(action: EditLocationAction(source: .timeline)),
        .new(action: LockAction(source: .timeline)),
        .new(action: StackAction(source: .timeline)),
        .new(action: CleanupLocalAction(source: .timeline)),
      ],
      slivers: [
        const AddToAlbumHeader(),
        AlbumSelector(onAlbumSelected: addToAlbum, onKeyboardExpanded: onKeyboardExpand),
      ],
    );
  }
}
