import 'package:flutter/services.dart';
import 'package:universalphotos_ui/src/components/text_input.dart';

/// An UniversalPhotosTextInput customized for receiving email addresses
class UniversalPhotosEmailInput extends UniversalPhotosTextInput {
  const UniversalPhotosEmailInput({
    super.key,
    super.controller,
    super.focusNode,
    super.label,
    super.hintText,
    super.validator,
    super.onSubmit,
    super.keyboardAction,
    super.suffixIcon,
    super.enabled,
    super.autofocus,
    super.autovalidateMode,
  }) : super(
         keyboardType: .emailAddress,
         autofillHints: const [AutofillHints.email],
         autocorrect: false,
         smartDashesType: .disabled,
         smartQuotesType: .disabled,
       );
}
