import 'package:flutter/material.dart';
import 'package:universalphotos_ui/src/components/text_button.dart';
import 'package:universalphotos_ui/src/previews.dart';
import 'package:universalphotos_ui/src/types.dart';

void _previewNoop() {}

@UniversalPhotosPreview(group: 'TextButton', name: 'Variants')
Widget previewTextButtonVariants() => const Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    UniversalPhotosTextButton(onPressed: _previewNoop, labelText: 'Filled', expanded: false),
    UniversalPhotosTextButton(onPressed: _previewNoop, labelText: 'Ghost', variant: UniversalPhotosVariant.ghost, expanded: false),
  ],
);

@UniversalPhotosPreview(group: 'TextButton', name: 'With Icons')
Widget previewTextButtonWithIcons() => const Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    UniversalPhotosTextButton(onPressed: _previewNoop, labelText: 'With Icon', icon: Icons.add, expanded: false),
    UniversalPhotosTextButton(
      onPressed: _previewNoop,
      labelText: 'Download',
      icon: Icons.download,
      variant: UniversalPhotosVariant.ghost,
      expanded: false,
    ),
  ],
);

@UniversalPhotosPreview(group: 'TextButton', name: 'Loading')
Widget previewTextButtonLoading() => UniversalPhotosTextButton(
  onPressed: () => Future<void>.delayed(const Duration(seconds: 2)),
  labelText: 'Click me',
  expanded: false,
);

@UniversalPhotosPreview(group: 'TextButton', name: 'Disabled')
Widget previewTextButtonDisabled() => const Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    UniversalPhotosTextButton(onPressed: _previewNoop, labelText: 'Disabled', disabled: true, expanded: false),
    UniversalPhotosTextButton(
      onPressed: _previewNoop,
      labelText: 'Disabled Ghost',
      variant: UniversalPhotosVariant.ghost,
      disabled: true,
      expanded: false,
    ),
  ],
);
