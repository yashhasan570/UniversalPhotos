import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:universal_photos/entities/store.entity.dart';
import 'package:universal_photos/services/app_settings.service.dart';

ValueNotifier<T> useAppSettingsState<T>(AppSettingsEnum<T> key) {
  final notifier = useState<T>(Store.get(key.storeKey, key.defaultValue));

  // Listen to changes to the notifier and update app settings
  useValueChanged(notifier.value, (_, _) => unawaited(Store.put(key.storeKey, notifier.value)));

  return notifier;
}
