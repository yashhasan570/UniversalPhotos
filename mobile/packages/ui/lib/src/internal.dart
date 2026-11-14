import 'package:flutter/material.dart';
import 'package:universalphotos_ui/src/color_override.dart';
import 'package:universalphotos_ui/src/translation.dart';

extension TranslationHelper on BuildContext {
  UniversalPhotosTranslations get translations => UniversalPhotosTranslationProvider.of(this);
}

extension ColorHelper on BuildContext {
  Color? get colorOverride => UniversalPhotosColorOverride.maybeOf(this);
}
