import 'package:flutter/material.dart';
import 'package:universal_photos_ui/src/components/email_input.dart';
import 'package:universal_photos_ui/src/previews.dart';

@UniversalPhotosPreview(group: 'EmailInput', name: 'Basic')
Widget previewEmailInput() => const _PreviewEmailInput();

class _PreviewEmailInput extends StatefulWidget {
  const _PreviewEmailInput();

  @override
  State<_PreviewEmailInput> createState() => _PreviewEmailInputState();
}

class _PreviewEmailInputState extends State<_PreviewEmailInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UniversalPhotosEmailInput(label: 'Email', hintText: 'user@', controller: _controller);
  }
}
