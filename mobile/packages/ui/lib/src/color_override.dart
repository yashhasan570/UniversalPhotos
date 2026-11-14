import 'package:flutter/widgets.dart';

class UniversalPhotosColorOverride extends InheritedWidget {
  const UniversalPhotosColorOverride({super.key, required this.color, required super.child});

  final Color? color;

  static Color? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UniversalPhotosColorOverride>()?.color;

  @override
  bool updateShouldNotify(UniversalPhotosColorOverride oldWidget) => color != oldWidget.color;
}
