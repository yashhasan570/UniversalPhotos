import 'dart:async';

import 'package:flutter/material.dart';
import 'package:universal_photos_ui/universal_photos_ui.dart';

class UniversalPhotosTextButton extends StatefulWidget {
  final String labelText;
  final IconData? icon;
  final FutureOr<void> Function() onPressed;
  final FutureOr<void> Function()? onLongPress;
  final UniversalPhotosVariant variant;
  final bool expanded;
  final bool disabled;
  final bool? loading;

  const UniversalPhotosTextButton({
    super.key,
    required this.labelText,
    this.icon,
    required this.onPressed,
    this.onLongPress,
    this.variant = .filled,
    this.expanded = true,

    this.disabled = false,
    this.loading,
  });

  @override
  State<UniversalPhotosTextButton> createState() => _UniversalPhotosTextButtonState();
}

class _UniversalPhotosTextButtonState extends State<UniversalPhotosTextButton> {
  bool _running = false;
  bool get _isLoading => widget.loading ?? _running;
  bool get _isDisabled => widget.disabled || _isLoading;

  Future<void> _runAction(FutureOr<void> Function() action) async {
    if (_running) {
      return;
    }

    setState(() => _running = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _running = false);
      }
    }
  }

  VoidCallback? get _onPressed => _isDisabled ? null : () => _runAction(widget.onPressed);

  VoidCallback? get _onLongPress =>
      _isDisabled || widget.onLongPress == null ? null : () => _runAction(widget.onLongPress!);

  @override
  Widget build(BuildContext context) {
    final Widget? icon = _isLoading
        ? const SizedBox.square(
            dimension: UniversalPhotosIconSize.md,
            child: CircularProgressIndicator(strokeWidth: UniversalPhotosBorderWidth.lg),
          )
        : widget.icon != null
        ? Icon(widget.icon, fontWeight: .w600)
        : null;

    final label = Text(
      widget.labelText,
      style: const .new(fontSize: UniversalPhotosTextSize.body, fontWeight: .bold),
    );
    final style = ElevatedButton.styleFrom(padding: const .symmetric(vertical: UniversalPhotosSpacing.md));

    final button = switch (widget.variant) {
      UniversalPhotosVariant.filled => ElevatedButton.icon(
        style: style,
        onPressed: _onPressed,
        onLongPress: _onLongPress,
        icon: icon,
        label: label,
      ),
      UniversalPhotosVariant.ghost => TextButton.icon(
        style: style,
        onPressed: _onPressed,
        onLongPress: _onLongPress,
        icon: icon,
        label: label,
      ),
    };

    if (widget.expanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
