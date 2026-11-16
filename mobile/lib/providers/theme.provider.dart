import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos_mobile/providers/infrastructure/settings.provider.dart';
import 'package:universal_photos_mobile/theme/color_scheme.dart';
import 'package:universal_photos_mobile/theme/dynamic_theme.dart';
import 'package:universal_photos_mobile/theme/theme_data.dart';

// Provider for current selected theme
final universal_photosThemeProvider = StateProvider<UniversalPhotosTheme>((ref) {
  final themeConfig = ref.watch(appConfigProvider.select((config) => config.theme));

  final UniversalPhotosTheme? dynamicTheme = DynamicTheme.theme;
  final currentTheme = (themeConfig.dynamicTheme && dynamicTheme != null)
      ? dynamicTheme
      : themeConfig.primaryColor.themeOfPreset;

  return themeConfig.colorfulInterface ? currentTheme : decolorizeSurfaces(theme: currentTheme);
});
