import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/domain/services/partner.service.dart';
import 'package:universal_photos/domain/services/user.service.dart';
import 'package:universal_photos/infrastructure/repositories/user_api.repository.dart';
import 'package:universal_photos/providers/api.provider.dart';
import 'package:universal_photos/providers/infrastructure/db.provider.dart';
import 'package:universal_photos/providers/infrastructure/store.provider.dart';
import 'package:universal_photos/repositories/partner_api.repository.dart';

final userApiRepositoryProvider = Provider((ref) => UserApiRepository(ref.watch(apiServiceProvider).usersApi));

final userServiceProvider = Provider(
  (ref) => UserService(
    userApiRepository: ref.watch(userApiRepositoryProvider),
    userRepository: ref.watch(driftProvider).userRepository,
    storeService: ref.watch(storeServiceProvider),
  ),
);

final partnerServiceProvider = Provider<PartnerService>((ref) {
  final db = ref.watch(driftProvider);
  return PartnerService(db.userRepository, db.partnerRepository, ref.watch(partnerApiRepositoryProvider));
});
