import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/domain/services/map.service.dart';
import 'package:universal_photos/presentation/widgets/map/map.state.dart';
import 'package:universal_photos/providers/infrastructure/db.provider.dart';
import 'package:universal_photos/providers/infrastructure/timeline.provider.dart';
import 'package:universal_photos/providers/user.provider.dart';

final mapServiceProvider = Provider<MapService>(
  (ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      throw Exception('User must be logged in to access map');
    }

    final users = ref.watch(mapStateProvider).withPartners
        ? ref.watch(timelineUsersProvider).valueOrNull ?? [user.id]
        : [user.id];

    final mapFactory = MapFactory(mapRepository: ref.watch(driftProvider).mapRepository);
    final mapService = mapFactory.remote(users, ref.watch(mapStateProvider).toOptions());
    return mapService;
  },
  // Empty dependencies to inform the framework that this provider
  // might be used in a ProviderScope
  dependencies: const [],
);
