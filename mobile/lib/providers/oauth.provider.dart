import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/providers/api.provider.dart';
import 'package:universal_photos/services/oauth.service.dart';

final oAuthServiceProvider = Provider((ref) => OAuthService(ref.watch(apiServiceProvider)));
