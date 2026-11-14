import 'package:flutter/material.dart';
import 'package:universalphotos_ui/src/components/password_input.dart';
import 'package:universalphotos_ui/src/previews.dart';

@UniversalPhotosPreview(group: 'PasswordInput', name: 'With Validator')
Widget previewPasswordInput() => UniversalPhotosPasswordInput(
      label: 'Password',
      hintText: 'Enter your password',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
    );
