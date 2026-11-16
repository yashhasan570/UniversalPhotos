import 'dart:async';

import 'package:flutter/material.dart';
import 'package:universal_photos_ui/src/constants.dart';
import 'package:universal_photos_ui/src/internal.dart';

class UniversalPhotosMenu extends StatefulWidget {
  final List<Widget> children;
  final MenuAnchorChildBuilder builder;
  final MenuStyle? style;
  final bool consumeOutsideTap;
  final Widget? child;

  const UniversalPhotosMenu({
    super.key,
    required this.children,
    required this.builder,
    this.style,
    this.consumeOutsideTap = false,
    this.child,
  });

  @override
  State<UniversalPhotosMenu> createState() => _UniversalPhotosMenuState();
}

class _UniversalPhotosMenuState extends State<UniversalPhotosMenu> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return _UniversalPhotosMenuScope(
      controller: _controller,
      child: MenuAnchor(
        controller: _controller,
        style: widget.style,
        consumeOutsideTap: widget.consumeOutsideTap,
        menuChildren: widget.children,
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

class _UniversalPhotosMenuScope extends InheritedWidget {
  final MenuController controller;

  const _UniversalPhotosMenuScope({required this.controller, required super.child});

  static MenuController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_UniversalPhotosMenuScope>()?.controller;

  @override
  bool updateShouldNotify(_UniversalPhotosMenuScope oldWidget) => controller != oldWidget.controller;
}

class UniversalPhotosMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final FutureOr<void> Function() onPressed;
  final bool disabled;

  const UniversalPhotosMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.disabled = false,
  });

  @override
  State<UniversalPhotosMenuItem> createState() => _UniversalPhotosMenuItemState();
}

class _UniversalPhotosMenuItemState extends State<UniversalPhotosMenuItem> {
  Future<void> _onPressed(MenuController? controller) async {
    try {
      await widget.onPressed();
    } finally {
      controller?.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _UniversalPhotosMenuScope.maybeOf(context);
    return MenuItemButton(
      onPressed: widget.disabled ? null : () => _onPressed(controller),
      closeOnActivate: controller == null,
      style: MenuItemButton.styleFrom(
        foregroundColor: context.colorOverride,
        alignment: .centerLeft,
        padding: const .symmetric(horizontal: UniversalPhotosSpacing.lg, vertical: UniversalPhotosSpacing.md),
      ),
      leadingIcon: Icon(widget.icon, size: UniversalPhotosIconSize.sm),
      child: Text(widget.label, style: const .new(fontSize: UniversalPhotosTextSize.body)),
    );
  }
}
