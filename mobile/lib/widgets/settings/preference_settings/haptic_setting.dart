import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:universal_photos/generated/translations.g.dart';
import 'package:universal_photos/services/app_settings.service.dart';
import 'package:universal_photos/utils/hooks/app_settings_update_hook.dart';
import 'package:universalphotos_ui/universalphotos_ui.dart';

class HapticSetting extends HookWidget {
  const HapticSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final hapticFeedbackSetting = useAppSettingsState(AppSettingsEnum.enableHapticFeedback);
    final isHapticFeedbackEnabled = useValueNotifier(hapticFeedbackSetting.value);

    void onHapticFeedbackChange(bool isEnabled) {
      hapticFeedbackSetting.value = isEnabled;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingGroupTitle(title: context.t.haptic_feedback_title, icon: Icons.vibration_outlined),
        SettingsSwitchListTile(
          valueNotifier: isHapticFeedbackEnabled,
          title: context.t.enabled,
          onChanged: onHapticFeedbackChange,
        ),
      ],
    );
  }
}
