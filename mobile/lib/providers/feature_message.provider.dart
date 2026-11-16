import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos_mobile/domain/services/feature_message.service.dart';
import 'package:universal_photos_mobile/providers/infrastructure/settings.provider.dart';

final featureMessageServiceProvider = Provider<FeatureMessageService>(
  (ref) => FeatureMessageService(ref.read(settingsProvider)),
);
