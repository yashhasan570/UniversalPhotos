import 'package:universal_photos/domain/models/feature_message.model.dart';
import 'package:universal_photos/domain/models/settings_key.dart';
import 'package:universal_photos/infrastructure/repositories/settings.repository.dart';

class FeatureMessageService {
  final SettingsRepository _settingsRepository;

  const FeatureMessageService(this._settingsRepository);

  bool shouldShow() {
    final seen = _settingsRepository.appConfig.featureMessage.seenRelease;
    return visibleFeatureMessageHighlights.isNotEmpty && featureMessageRelease > seen;
  }

  Future<void> markSeen() => _settingsRepository.write(SettingsKey.featureMessageSeenRelease, featureMessageRelease);
}
