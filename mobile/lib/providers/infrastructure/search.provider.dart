import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos_mobile/domain/services/search.service.dart';
import 'package:universal_photos_mobile/infrastructure/repositories/search_api.repository.dart';
import 'package:universal_photos_mobile/providers/api.provider.dart';

final searchApiRepositoryProvider = Provider((ref) => SearchApiRepository(ref.watch(apiServiceProvider).searchApi));

final searchServiceProvider = Provider((ref) => SearchService(ref.watch(searchApiRepositoryProvider)));
