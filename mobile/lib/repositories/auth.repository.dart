import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/data/db/main/database.dart';
import 'package:universal_photos/infrastructure/repositories/settings.repository.dart';
import 'package:universal_photos/infrastructure/repositories/sync_stream.repository.dart';
import 'package:universal_photos/models/auth/auxilary_endpoint.model.dart';
import 'package:universal_photos/providers/infrastructure/db.provider.dart';
import 'package:universal_photos/providers/infrastructure/settings.provider.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(driftProvider), ref.watch(settingsProvider)),
);

class AuthRepository {
  final Drift _drift;
  final SettingsRepository _settings;

  const AuthRepository(this._drift, this._settings);

  Future<void> clearLocalData() async {
    await SyncStreamRepository(_drift).reset();
  }

  bool getEndpointSwitchingFeature() {
    return _settings.appConfig.network.autoEndpointSwitching;
  }

  String? getPreferredWifiName() {
    return _settings.appConfig.network.preferredWifiName;
  }

  String? getLocalEndpoint() {
    return _settings.appConfig.network.localEndpoint;
  }

  List<AuxilaryEndpoint> getExternalEndpointList() {
    return _settings.appConfig.network.externalEndpointList
        .map((url) => AuxilaryEndpoint(url: url, status: .valid))
        .toList();
  }
}
