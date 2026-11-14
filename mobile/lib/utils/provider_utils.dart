import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/data/server/activity.dart';
import 'package:universal_photos/data/server/person.dart';
import 'package:universal_photos/providers/infrastructure/search.provider.dart';
import 'package:universal_photos/providers/infrastructure/user.provider.dart';
import 'package:universal_photos/repositories/album_api_repository.dart';
import 'package:universal_photos/repositories/asset_api.repository.dart';
import 'package:universal_photos/repositories/partner_api.repository.dart';

void invalidateAllApiRepositoryProviders(WidgetRef ref) {
  ref.invalidate(userApiRepositoryProvider);
  ref.invalidate(activityApiRepositoryProvider);
  ref.invalidate(partnerApiRepositoryProvider);
  ref.invalidate(personApiRepositoryProvider);
  ref.invalidate(assetApiRepositoryProvider);
  ref.invalidate(searchApiRepositoryProvider);

  // Drift
  ref.invalidate(albumApiRepositoryProvider);
}
