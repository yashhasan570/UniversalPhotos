import 'package:flutter/material.dart';
import 'package:universalphotos_ui/src/components/url_input.dart';
import 'package:universalphotos_ui/src/previews.dart';

@UniversalPhotosPreview(group: 'URLInput', name: 'Basic')
Widget previewUrlInput() => const _PreviewUrlInput();

class _PreviewUrlInput extends StatefulWidget {
  const _PreviewUrlInput();

  @override
  State<_PreviewUrlInput> createState() => _PreviewUrlInputState();
}

class _PreviewUrlInputState extends State<_PreviewUrlInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UniversalPhotosURLInput(label: 'Server URL', hintText: 'https://demo.com', controller: _controller);
  }
}
