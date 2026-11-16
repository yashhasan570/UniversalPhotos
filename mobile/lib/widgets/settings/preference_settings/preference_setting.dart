import 'package:flutter/material.dart';
import 'package:universal_photos_mobile/widgets/settings/preference_settings/haptic_setting.dart';
import 'package:universal_photos_mobile/widgets/settings/preference_settings/share_setting.dart';
import 'package:universal_photos_mobile/widgets/settings/preference_settings/theme_setting.dart';
import 'package:universal_photos_ui/universal_photos_ui.dart';

class PreferenceSetting extends StatelessWidget {
  const PreferenceSetting({super.key});

  @override
  Widget build(BuildContext context) {
    const preferenceSettings = [ThemeSetting(), HapticSetting(), ShareSetting()];

    return const SettingsSubPageScaffold(settings: preferenceSettings, showDivider: true);
  }
}
