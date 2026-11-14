import 'package:flutter/material.dart';
import 'package:universalphotos_ui/src/components/column_button.dart';
import 'package:universalphotos_ui/src/previews.dart';

void _previewNoop() {}

@UniversalPhotosPreview(group: 'ColumnButton', name: 'Default')
Widget previewColumnButtonDefault() => const Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    UniversalPhotosColumnButton(onPressed: _previewNoop, icon: Icons.favorite_border_rounded, label: 'Favorite'),
    UniversalPhotosColumnButton(onPressed: _previewNoop, icon: Icons.archive_outlined, label: 'Archive'),
    UniversalPhotosColumnButton(onPressed: _previewNoop, icon: Icons.delete_outline_rounded, label: 'Delete'),
  ],
);

@UniversalPhotosPreview(group: 'ColumnButton', name: 'Loading')
Widget previewColumnButtonLoading() => UniversalPhotosColumnButton(
  onPressed: () => Future<void>.delayed(const .new(seconds: 2)),
  icon: Icons.download,
  label: 'Download',
);

@UniversalPhotosPreview(group: 'ColumnButton', name: 'Disabled')
Widget previewColumnButtonDisabled() =>
    const UniversalPhotosColumnButton(onPressed: _previewNoop, icon: Icons.ios_share_rounded, label: 'Share', disabled: true);
