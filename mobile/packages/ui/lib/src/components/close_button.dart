import 'package:flutter/material.dart';
import 'package:universal_photos_ui/src/components/icon_button.dart';
import 'package:universal_photos_ui/src/types.dart';

class UniversalPhotosCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final UniversalPhotosVariant variant;
  final UniversalPhotosColor color;

  const UniversalPhotosCloseButton({
    super.key,
    this.onPressed,
    this.color = UniversalPhotosColor.primary,
    this.variant = UniversalPhotosVariant.ghost,
  });

  @override
  Widget build(BuildContext context) => UniversalPhotosIconButton(
    icon: Icons.close,
    color: color,
    variant: variant,
    onPressed: onPressed ?? () => Navigator.of(context).pop(),
  );
}
