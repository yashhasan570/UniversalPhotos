import 'dart:async';

import 'package:flutter/material.dart';
import 'package:universal_photos_ui/universal_photos_ui.dart';
import 'package:universal_photos_ui/src/internal.dart';

class UniversalPhotosFormController extends ChangeNotifier {
  UniversalPhotosFormController({this.onSubmit});

  FutureOr<void> Function()? onSubmit;
  final formKey = GlobalKey<FormState>();

  bool _isDisposed = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> submit() async {
    if (_isLoading) {
      return;
    }
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      await onSubmit?.call();
    } finally {
      _isLoading = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }
}

class UniversalPhotosForm extends StatefulWidget {
  final FutureOr<void> Function()? onSubmit;
  final Widget Function(BuildContext context, UniversalPhotosFormController form) builder;
  final String? submitText;
  final IconData? submitIcon;

  const UniversalPhotosForm({super.key, this.onSubmit, this.submitText, this.submitIcon, required this.builder});

  @override
  State<UniversalPhotosForm> createState() => _UniversalPhotosFormState();
}

class _UniversalPhotosFormState extends State<UniversalPhotosForm> {
  late final UniversalPhotosFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UniversalPhotosFormController(onSubmit: widget.onSubmit);
  }

  @override
  void didUpdateWidget(UniversalPhotosForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.onSubmit = widget.onSubmit;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submitText = widget.submitText ?? context.translations.submit;
    return Form(
      key: _controller.formKey,
      child: Column(
        spacing: UniversalPhotosSpacing.md,
        children: [
          widget.builder(context, _controller),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => UniversalPhotosTextButton(
              labelText: submitText,
              icon: widget.submitIcon,
              variant: .filled,
              loading: _controller.isLoading,
              onPressed: _controller.submit,
              disabled: _controller.onSubmit == null,
            ),
          ),
        ],
      ),
    );
  }
}
