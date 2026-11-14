import 'package:flutter/material.dart';
import 'package:universalphotos_ui/src/components/formatted_text.dart';
import 'package:universalphotos_ui/src/previews.dart';

@UniversalPhotosPreview(group: 'FormattedText', name: 'Bold')
Widget previewFormattedTextBold() => const UniversalPhotosFormattedText('This is <b>bold text</b>.');

@UniversalPhotosPreview(group: 'FormattedText', name: 'Links')
Widget previewFormattedTextLinks() => const _PreviewFormattedTextLinks();

@UniversalPhotosPreview(group: 'FormattedText', name: 'Mixed Content')
Widget previewFormattedTextMixed() => const _PreviewFormattedTextMixed();

class _PreviewFormattedTextLinks extends StatelessWidget {
  const _PreviewFormattedTextLinks();

  @override
  Widget build(BuildContext context) {
    return UniversalPhotosFormattedText(
      'Read the <docs-link>documentation</docs-link> or visit <github-link>GitHub</github-link>.',
      spanBuilder: (tag) => FormattedSpan(
        onTap: switch (tag) {
          'docs-link' =>
            () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Docs link clicked!'))),
          'github-link' =>
            () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('GitHub link clicked!'))),
          _ => null,
        },
      ),
    );
  }
}

class _PreviewFormattedTextMixed extends StatelessWidget {
  const _PreviewFormattedTextMixed();

  @override
  Widget build(BuildContext context) {
    return UniversalPhotosFormattedText(
      'You can use <b>bold text</b> and <link>links</link> together.',
      spanBuilder: (tag) => switch (tag) {
        'b' => const FormattedSpan(style: TextStyle(fontWeight: FontWeight.bold)),
        _ => FormattedSpan(
            onTap: () =>
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link clicked!'))),
          ),
      },
    );
  }
}
