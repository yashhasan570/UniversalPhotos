import 'package:flutter/material.dart';
import 'package:universal_photos/presentation/actions/action.widget.dart';
import 'package:universal_photos/presentation/actions/asset_debug.action.dart';
import 'package:universal_photos/presentation/actions/delete.action.dart';
import 'package:universal_photos/presentation/actions/download.action.dart';
import 'package:universal_photos/presentation/actions/lock.action.dart';
import 'package:universal_photos/presentation/actions/share.action.dart';
import 'package:universal_photos/presentation/widgets/bottom_sheet/base_bottom_sheet.widget.dart';

class LockedFolderBottomSheet extends StatelessWidget {
  const LockedFolderBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseBottomSheet(
      initialChildSize: 0.25,
      maxChildSize: 0.4,
      shouldCloseOnMinExtent: false,
      actions: <ActionColumnButton>[
        .new(action: AssetDebugAction(source: .timeline)),
        .new(action: ShareAction(source: .timeline)),
        .new(action: DownloadAction(source: .timeline)),
        .new(action: DeleteAction(source: .timeline)),
        .new(action: LockAction(source: .timeline)),
      ],
    );
  }
}
