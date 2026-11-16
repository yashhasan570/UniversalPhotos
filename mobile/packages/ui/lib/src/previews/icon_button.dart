import 'package:flutter/material.dart';
import 'package:universal_photos_ui/src/components/icon_button.dart';
import 'package:universal_photos_ui/src/previews.dart';
import 'package:universal_photos_ui/src/types.dart';

void _previewNoop() {}

@UniversalPhotosPreview(group: 'IconButton', name: 'Variants')
Widget previewIconButtonVariants() => const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        UniversalPhotosIconButton(icon: Icons.add, onPressed: _previewNoop),
        UniversalPhotosIconButton(icon: Icons.edit, onPressed: _previewNoop, variant: UniversalPhotosVariant.ghost),
      ],
    );

@UniversalPhotosPreview(group: 'IconButton', name: 'Colors')
Widget previewIconButtonColors() => const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        UniversalPhotosIconButton(icon: Icons.favorite, onPressed: _previewNoop),
        UniversalPhotosIconButton(icon: Icons.delete, onPressed: _previewNoop, color: UniversalPhotosColor.secondary),
      ],
    );

@UniversalPhotosPreview(group: 'IconButton', name: 'Disabled')
Widget previewIconButtonDisabled() => const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        UniversalPhotosIconButton(icon: Icons.settings, onPressed: _previewNoop, disabled: true),
        UniversalPhotosIconButton(
          icon: Icons.settings,
          onPressed: _previewNoop,
          disabled: true,
          variant: UniversalPhotosVariant.ghost,
        ),
      ],
    );
