import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/domain/services/feature_message.service.dart';
import 'package:universal_photos/providers/infrastructure/settings.provider.dart';

final featureMessageServiceProvider = Provider<FeatureMessageService>(
  (ref) => FeatureMessageService(ref.read(settingsProvider)),
);
