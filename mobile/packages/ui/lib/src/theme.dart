import 'package:flutter/material.dart';
import 'package:universalphotos_ui/src/constants.dart';
import 'package:material_color_utilities/blend/blend.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/palettes/tonal_palette.dart';

class UniversalPhotosThemeProvider extends StatelessWidget {
  final ColorScheme colorScheme;
  final Widget child;

  const UniversalPhotosThemeProvider({super.key, required this.colorScheme, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [UniversalPhotosColors.harmonized(colorScheme)],
        colorScheme: colorScheme,
        brightness: colorScheme.brightness,
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: WidgetStateInputBorder.resolveWith((states) {
            final color = states.contains(WidgetState.error)
                ? colorScheme.error
                : states.contains(WidgetState.focused)
                ? colorScheme.primary
                : colorScheme.outline;
            return OutlineInputBorder(
              borderSide: BorderSide(color: color),
              borderRadius: const BorderRadius.all(Radius.circular(UniversalPhotosRadius.md)),
            );
          }),
          labelStyle: WidgetStateTextStyle.resolveWith((states) {
            final color = states.contains(WidgetState.error) ? colorScheme.error : colorScheme.primary;
            return TextStyle(color: color, fontWeight: FontWeight.w600);
          }),
          hintStyle: const TextStyle(fontSize: UniversalPhotosTextSize.body),
          errorStyle: TextStyle(color: colorScheme.error, fontWeight: FontWeight.w600),
        ),
      ),
      child: child,
    );
  }
}

class UniversalPhotosColors extends ThemeExtension<UniversalPhotosColors> {
  final Color info;
  final Color onInfo;
  final Color success;
  final Color onSuccess;
  final Color error;
  final Color onError;

  const UniversalPhotosColors({
    required this.info,
    required this.onInfo,
    required this.success,
    required this.onSuccess,
    required this.error,
    required this.onError,
  });

  factory UniversalPhotosColors.harmonized(ColorScheme scheme) {
    final (info, onInfo) = scheme.harmonized(const Color(0xFF1984E9));
    final (success, onSuccess) = scheme.harmonized(const Color(0xFF10C14D));
    final (error, onError) = scheme.harmonized(const Color(0xFFFA2921));
    return UniversalPhotosColors(
      info: info,
      onInfo: onInfo,
      success: success,
      onSuccess: onSuccess,
      error: error,
      onError: onError,
    );
  }

  @override
  UniversalPhotosColors copyWith({Color? info, Color? onInfo, Color? success, Color? onSuccess, Color? error, Color? onError}) {
    return UniversalPhotosColors(
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      error: error ?? this.error,
      onError: onError ?? this.onError,
    );
  }

  @override
  UniversalPhotosColors lerp(UniversalPhotosColors? other, double t) {
    if (other == null) {
      return this;
    }
    return UniversalPhotosColors(
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
    );
  }
}

extension on ColorScheme {
  (Color container, Color onContainer) harmonized(Color seed) {
    final hct = Hct.fromInt(Blend.harmonize(seed.toARGB32(), primary.toARGB32()));
    final tones = TonalPalette.of(hct.hue, hct.chroma);
    final isDark = brightness == Brightness.dark;
    return (Color(tones.get(isDark ? 30 : 90)), Color(tones.get(isDark ? 90 : 10)));
  }
}
