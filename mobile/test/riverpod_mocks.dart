import 'package:universal_photos/models/server_info/server_version.model.dart';
import 'package:universal_photos/providers/server_info.provider.dart';

class StubServerInfoNotifier extends ServerInfoNotifier {
  StubServerInfoNotifier(super.serverInfoService, {required ServerVersion version}) {
    state = state.copyWith(serverVersion: version);
  }
}
