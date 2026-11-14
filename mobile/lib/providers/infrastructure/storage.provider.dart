import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/infrastructure/repositories/storage.repository.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) => StorageRepository());
