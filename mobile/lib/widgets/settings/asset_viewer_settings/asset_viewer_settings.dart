import 'package:flutter/material.dart';
import 'package:universal_photos/widgets/settings/asset_viewer_settings/image_viewer_quality_setting.dart';
import 'package:universal_photos/widgets/settings/asset_viewer_settings/image_viewer_tap_to_navigate_setting.dart';
import 'package:universal_photos/widgets/settings/asset_viewer_settings/slideshow_settings.dart';
import 'package:universal_photos/widgets/settings/asset_viewer_settings/video_viewer_settings.dart';
import 'package:universalphotos_ui/universalphotos_ui.dart';

class AssetViewerSettings extends StatelessWidget {
  const AssetViewerSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final assetViewerSetting = [
      const ImageViewerQualitySetting(),
      const ImageViewerTapToNavigateSetting(),
      const VideoViewerSettings(),
      const SlideshowSettings(),
    ];

    return SettingsSubPageScaffold(settings: assetViewerSetting, showDivider: true);
  }
}
