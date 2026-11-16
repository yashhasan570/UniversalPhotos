import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos_mobile/presentation/actions/action.dart';
import 'package:universal_photos_ui/universal_photos_ui.dart';

abstract class ActionWidget extends ConsumerWidget {
  final ActionBuilder action;

  const ActionWidget({super.key, required this.action});

  Widget builder(BuildContext context, WidgetRef ref, ActionItem action);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionItem = action.create(context, ref);
    if (actionItem == null) {
      return const SizedBox.shrink();
    }

    return builder(context, ref, actionItem);
  }
}

class ActionColumnButton extends ActionWidget {
  const ActionColumnButton({super.key, required super.action});

  @override
  Widget builder(BuildContext context, WidgetRef ref, ActionItem action) => UniversalPhotosColumnButton(
    icon: action.icon,
    label: action.label,
    onPressed: action.onAction,
    onLongPress: action.onSecondaryAction,
  );
}

class ActionIconButton extends ActionWidget {
  final UniversalPhotosVariant variant;

  const ActionIconButton({super.key, required super.action, this.variant = .ghost});

  @override
  Widget builder(BuildContext context, WidgetRef ref, ActionItem action) => UniversalPhotosIconButton(
    icon: action.icon,
    onPressed: action.onAction,
    onLongPress: action.onSecondaryAction,
    variant: variant,
  );
}

class ActionButton extends ActionWidget {
  final UniversalPhotosVariant variant;

  const ActionButton({super.key, required super.action, this.variant = .ghost});

  @override
  Widget builder(BuildContext context, WidgetRef ref, ActionItem action) => UniversalPhotosTextButton(
    labelText: action.label,
    icon: action.icon,
    onPressed: action.onAction,
    onLongPress: action.onSecondaryAction,
    variant: variant,
  );
}

class ActionMenuItem extends ActionWidget {
  const ActionMenuItem({super.key, required super.action});

  @override
  Widget builder(BuildContext context, WidgetRef ref, ActionItem action) =>
      UniversalPhotosMenuItem(icon: action.icon, label: action.label, onPressed: action.onAction);
}
