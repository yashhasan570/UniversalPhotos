import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/generated/translations.g.dart';
import 'package:universal_photos/providers/app_settings.provider.dart';
import 'package:universal_photos/providers/infrastructure/settings.provider.dart';
import 'package:universalphotos_ui/universalphotos_ui.dart';

class LayoutSettings extends HookConsumerWidget {
  const LayoutSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tilesPerRow = useState(ref.watch(appConfigProvider.select((s) => s.timeline.tilesPerRow)));
    useValueChanged<int, void>(tilesPerRow.value, (_, _) {
      unawaited(ref.read(settingsProvider).write(.timelineTilesPerRow, tilesPerRow.value));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingGroupTitle(title: context.t.asset_list_layout_sub_title, icon: Icons.view_module_outlined),
        SettingsSliderListTile(
          valueNotifier: tilesPerRow,
          text: context.t.theme_setting_asset_list_tiles_per_row_title(count: tilesPerRow.value),
          label: "${tilesPerRow.value}",
          maxValue: 6,
          minValue: 2,
          noDivisons: 4,
          onChangeEnd: (value) {
            ref.invalidate(appSettingsServiceProvider);
          },
        ),
      ],
    );
  }
}
