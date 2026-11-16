import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos_mobile/generated/translations.g.dart';
import 'package:universal_photos_mobile/providers/infrastructure/settings.provider.dart';
import 'package:universal_photos_ui/universal_photos_ui.dart';

class ImageViewerTapToNavigateSetting extends HookConsumerWidget {
  const ImageViewerTapToNavigateSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tapToNavigate = useState(ref.watch(appConfigProvider).viewer.tapToNavigate);
    useValueChanged<bool, void>(tapToNavigate.value, (_, _) {
      unawaited(ref.read(settingsProvider).write(.viewerTapToNavigate, tapToNavigate.value));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSubTitle(title: context.t.setting_image_navigation_title),
        SettingsSwitchListTile(
          valueNotifier: tapToNavigate,
          title: context.t.setting_image_navigation_enable_title,
          subtitle: context.t.setting_image_navigation_enable_subtitle,
        ),
      ],
    );
  }
}
