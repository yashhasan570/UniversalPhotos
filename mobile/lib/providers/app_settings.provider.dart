import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/services/app_settings.service.dart';

final appSettingsServiceProvider = Provider((_) => const AppSettingsService());
