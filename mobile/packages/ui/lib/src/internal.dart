import 'package:flutter/material.dart';
import 'package:universal_photos_ui/src/color_override.dart';
import 'package:universal_photos_ui/src/translation.dart';

extension TranslationHelper on BuildContext {
  UniversalPhotosTranslations get translations => UniversalPhotosTranslationProvider.of(this);
}

extension ColorHelper on BuildContext {
  Color? get colorOverride => UniversalPhotosColorOverride.maybeOf(this);
}
