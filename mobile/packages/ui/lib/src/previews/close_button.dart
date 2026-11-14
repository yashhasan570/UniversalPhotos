import 'package:flutter/material.dart';
import 'package:universalphotos_ui/src/components/close_button.dart';
import 'package:universalphotos_ui/src/previews.dart';
import 'package:universalphotos_ui/src/types.dart';

void _previewNoop() {}

@UniversalPhotosPreview(group: 'CloseButton', name: 'Variants')
Widget previewCloseButtonVariants() => const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        UniversalPhotosCloseButton(onPressed: _previewNoop),
        UniversalPhotosCloseButton(onPressed: _previewNoop, variant: UniversalPhotosVariant.filled),
      ],
    );

@UniversalPhotosPreview(group: 'CloseButton', name: 'Colors')
Widget previewCloseButtonColors() => const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        UniversalPhotosCloseButton(onPressed: _previewNoop),
        UniversalPhotosCloseButton(onPressed: _previewNoop, color: UniversalPhotosColor.secondary),
      ],
    );
