import 'package:flutter/material.dart';

class UniversalPhotosTranslations {
  final String submit;
  final String password;
  final String undo;

  const UniversalPhotosTranslations({String? submit, String? password, String? undo})
    : submit = submit ?? 'Submit',
      password = password ?? 'Password',
      undo = undo ?? 'Undo';
}

class UniversalPhotosTranslationProvider extends InheritedWidget {
  final UniversalPhotosTranslations? translations;

  const UniversalPhotosTranslationProvider({super.key, this.translations, required super.child});

  static UniversalPhotosTranslations of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<UniversalPhotosTranslationProvider>();
    return provider?.translations ?? const .new();
  }

  @override
  bool updateShouldNotify(covariant UniversalPhotosTranslationProvider oldWidget) {
    return oldWidget.translations != translations;
  }
}
