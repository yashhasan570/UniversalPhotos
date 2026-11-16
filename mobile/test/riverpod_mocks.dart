import 'package:universal_photos_mobile/models/server_info/server_version.model.dart';
import 'package:universal_photos_mobile/providers/server_info.provider.dart';

class StubServerInfoNotifier extends ServerInfoNotifier {
  StubServerInfoNotifier(super.serverInfoService, {required ServerVersion version}) {
    state = state.copyWith(serverVersion: version);
  }
}
