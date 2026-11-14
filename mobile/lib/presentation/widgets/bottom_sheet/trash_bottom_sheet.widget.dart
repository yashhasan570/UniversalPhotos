import 'package:flutter/material.dart';
import 'package:universal_photos/extensions/build_context_extensions.dart';
import 'package:universal_photos/presentation/actions/action.widget.dart';
import 'package:universal_photos/presentation/actions/asset_debug.action.dart';
import 'package:universal_photos/presentation/actions/delete.action.dart';
import 'package:universal_photos/presentation/actions/restore.action.dart';

class TrashBottomBar extends StatelessWidget {
  const TrashBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: context.themeData.canvasColor,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: const SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <ActionColumnButton>[
              .new(action: AssetDebugAction(source: .timeline)),
              .new(action: DeleteAction(source: .timeline)),
              .new(action: RestoreAction(source: .timeline)),
            ],
          ),
        ),
      ),
    );
  }
}
