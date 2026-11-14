import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:universalphotos_ui/src/constants.dart';
import 'package:universalphotos_ui/src/internal.dart';

class UniversalPhotosColumnButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final FutureOr<void> Function() onPressed;
  final FutureOr<void> Function()? onLongPress;
  final bool disabled;
  final bool? loading;

  const UniversalPhotosColumnButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.onLongPress,
    this.disabled = false,
    this.loading,
  });

  @override
  State<UniversalPhotosColumnButton> createState() => _UniversalPhotosColumnButtonState();
}

class _UniversalPhotosColumnButtonState extends State<UniversalPhotosColumnButton> {
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
    final foreground = context.colorOverride ?? Theme.of(context).colorScheme.onSurface;

    return TextButton(
      onPressed: _onPressed,
      onLongPress: _onLongPress,
      style: TextButton.styleFrom(
        foregroundColor: foreground,
        padding: const .symmetric(horizontal: UniversalPhotosSpacing.sm, vertical: UniversalPhotosSpacing.md),
        tapTargetSize: .shrinkWrap,
        shape: const RoundedRectangleBorder(borderRadius: .all(.circular(UniversalPhotosRadius.xl))),
      ),
      child: ConstrainedBox(
        constraints: const .new(maxWidth: 90),
        child: Column(
          mainAxisSize: .min,
          children: [
            _isLoading
                ? const SizedBox.square(
                    dimension: UniversalPhotosIconSize.md,
                    child: CircularProgressIndicator(strokeWidth: UniversalPhotosBorderWidth.lg),
                  )
                : Icon(widget.icon, size: UniversalPhotosIconSize.md),
            const SizedBox(height: UniversalPhotosSpacing.sm),
            Text(
              widget.label,
              maxLines: 2,
              textAlign: .center,
              overflow: .ellipsis,
              style: const .new(fontSize: UniversalPhotosTextSize.body, fontWeight: .w500),
            ),
          ],
        ),
      ),
    );
  }
}
