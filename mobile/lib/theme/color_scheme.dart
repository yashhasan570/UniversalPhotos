import 'package:flutter/material.dart';
import 'package:universal_photos_mobile/constants/colors.dart';
import 'package:universal_photos_mobile/theme/theme_data.dart';

final Map<UniversalPhotosColorPreset, UniversalPhotosTheme> _themePresets = {
  UniversalPhotosColorPreset.indigo: UniversalPhotosTheme(
    light: ColorScheme.fromSeed(
      seedColor: universal_photosBrandColorLight,
    ).copyWith(primary: universal_photosBrandColorLight, onSurface: const Color.fromARGB(255, 34, 31, 32)),
    dark: ColorScheme.fromSeed(
      seedColor: universal_photosBrandColorDark,
      brightness: Brightness.dark,
    ).copyWith(primary: universal_photosBrandColorDark),
  ),
  UniversalPhotosColorPreset.deepPurple: UniversalPhotosTheme(
    light: ColorScheme.fromSeed(seedColor: const Color(0xFF6F43C0)),
    dark: ColorScheme.fromSeed(seedColor: const Color(0xFFD3BBFF), brightness: Brightness.dark),
  ),
  UniversalPhotosColorPreset.pink: UniversalPhotosTheme(
    light: ColorScheme.fromSeed(seedColor: const Color(0xFFED79B5)),
    dark: ColorScheme.fromSeed(seedColor: const Color(0xFFED79B5), brightness: Brightness.dark),
  ),
  UniversalPhotosColorPreset.red: UniversalPhotosTheme(
    light: ColorScheme.fromSeed(seedColor: const Color(0xFFC51C16)),
    dark: ColorScheme.fromSeed(seedColor: const Color(0xFFD3302F), brightness: Brightness.dark),
  ),
  UniversalPhotosColorPreset.orange: UniversalPhotosTheme(
    light: ColorScheme.fromSeed(
      seedColor: const Color(0xffff5b01),
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ),
    dark: ColorScheme.fromSeed(
      seedColor: const Color(0xFFCC6D08),
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ),
  ),
  UniversalPhotosColorPreset.yellow: UniversalPhotosTheme(
    light: ColorScheme.fromSeed(seedColor: const Color(0xFFFFB400)),
    dark: ColorScheme.fromSeed(seedColor: const Color(0xFFFFB400), brightness: Brightness.dark),
  ),
  UniversalPhotosColorPreset.lime: UniversalPhotosTheme(
    light: ColorScheme.fromSeed(seedColor: const Color(0xFFCDDC39)),
    dark: ColorScheme.fromSeed(seedColor: const Color(0xFFCDDC39), brightness: Brightness.dark),
  ),
  UniversalPhotosColorPreset.green: UniversalPhotosTheme(
    light: ColorScheme.fromSeed(seedColor: const Color(0xFF18C249)),
    dark: ColorScheme.fromSeed(seedColor: const Color(0xFF18C249), brightness: Brightness.dark),
  ),
  UniversalPhotosColorPreset.cyan: UniversalPhotosTheme(
    light: ColorScheme.fromSeed(seedColor: const Color(0xFF00BCD4)),
    dark: ColorScheme.fromSeed(seedColor: const Color(0xFF00BCD4), brightness: Brightness.dark),
  ),
  UniversalPhotosColorPreset.slateGray: UniversalPhotosTheme(
    light: ColorScheme.fromSeed(seedColor: const Color(0xFF696969), dynamicSchemeVariant: DynamicSchemeVariant.neutral),
    dark: ColorScheme.fromSeed(
      seedColor: const Color(0xff696969),
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    ),
  ),
};

extension UniversalPhotosColorModeExtension on UniversalPhotosColorPreset {
  UniversalPhotosTheme get themeOfPreset => _themePresets[this]!;
}
