import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/data/store.dart';
import 'package:universal_photos/domain/models/person.model.dart';
import 'package:universal_photos/extensions/build_context_extensions.dart';
import 'package:universal_photos/generated/translations.g.dart';
import 'package:universal_photos/utils/debug_print.dart';
import 'package:universal_photos/widgets/common/universalphotos_toast.dart';

class PersonNameEditForm extends ConsumerStatefulWidget {
  final Person person;

  const PersonNameEditForm({super.key, required this.person});

  @override
  ConsumerState<PersonNameEditForm> createState() => _PersonNameEditFormState();
}

class _PersonNameEditFormState extends ConsumerState<PersonNameEditForm> {
  late TextEditingController _formController;

  @override
  void initState() {
    super.initState();
    _formController = TextEditingController(text: widget.person.name);
  }

  Future<void> onEdit(String personId, String newName) async {
    try {
      final result = await ref.read(Store.people).updateName(personId, newName);
      if (result != 0 && mounted) {
        context.pop<String>(newName);
      }
    } catch (error) {
      dPrint(() => 'Error updating name: $error');

      if (!mounted) {
        return;
      }

      UniversalPhotosToast.show(
        context: context,
        msg: context.t.scaffold_body_error_occurred,
        gravity: ToastGravity.BOTTOM,
        toastType: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.t.edit_name, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: TextFormField(
          controller: _formController,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          decoration: InputDecoration(hintText: context.t.name, border: const OutlineInputBorder()),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(null),
          child: Text(
            context.t.cancel,
            style: TextStyle(color: Colors.red[300], fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () => onEdit(widget.person.id, _formController.text),
          child: Text(
            context.t.save,
            style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
