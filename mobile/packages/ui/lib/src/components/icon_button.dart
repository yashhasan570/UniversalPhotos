import 'dart:async';

import 'package:flutter/material.dart';
import 'package:universalphotos_ui/universalphotos_ui.dart';
import 'package:universalphotos_ui/src/internal.dart';

class UniversalPhotosIconButton extends StatefulWidget {
  final IconData icon;
  final FutureOr<void> Function() onPressed;
  final FutureOr<void> Function()? onLongPress;
  final UniversalPhotosVariant variant;
  final UniversalPhotosColor color;
  final bool disabled;
  final bool? loading;

  const UniversalPhotosIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.onLongPress,
    this.color = .primary,
    this.variant = .filled,
    this.disabled = false,
    this.loading,
  });

  @override
  State<UniversalPhotosIconButton> createState() => _UniversalPhotosIconButtonState();
}

class _UniversalPhotosIconButtonState extends State<UniversalPhotosIconButton> {
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
    final colorScheme = Theme.of(context).colorScheme;

    final background = switch (widget.variant) {
      .filled => switch (widget.color) {
        .primary => colorScheme.primary,
        .secondary => colorScheme.secondary,
      },
      .ghost => Colors.transparent,
    };

    final foreground =
        context.colorOverride ??
        switch (widget.variant) {
          .filled => switch (widget.color) {
            .primary => colorScheme.onPrimary,
            .secondary => colorScheme.onSecondary,
          },
          .ghost => switch (widget.color) {
            .primary => colorScheme.primary,
            .secondary => colorScheme.secondary,
          },
        };

    return IconButton(
      icon: _isLoading
          ? const SizedBox.square(
              dimension: UniversalPhotosIconSize.sm,
              child: CircularProgressIndicator(strokeWidth: UniversalPhotosBorderWidth.md),
            )
          : Icon(widget.icon),
      onPressed: _onPressed,
      onLongPress: _onLongPress,
      style: IconButton.styleFrom(backgroundColor: background, foregroundColor: foreground),
    );
  }
}
