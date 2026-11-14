import 'package:flutter/material.dart';
import 'package:universalphotos_ui/src/components/menu_item.dart';
import 'package:universalphotos_ui/src/previews.dart';

void _previewNoop() {}

@UniversalPhotosPreview(group: 'MenuItem', name: 'Default')
Widget previewMenuItemDefault() => const Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    UniversalPhotosMenuItem(onPressed: _previewNoop, icon: Icons.info_outline, label: 'Info'),
    UniversalPhotosMenuItem(onPressed: _previewNoop, icon: Icons.help_outline_rounded, label: 'Troubleshoot'),
    UniversalPhotosMenuItem(onPressed: _previewNoop, icon: Icons.cast_rounded, label: 'Cast'),
  ],
);

@UniversalPhotosPreview(group: 'MenuItem', name: 'Disabled')
Widget previewMenuItemDisabled() =>
    const UniversalPhotosMenuItem(onPressed: _previewNoop, icon: Icons.delete_outline_rounded, label: 'Delete', disabled: true);
