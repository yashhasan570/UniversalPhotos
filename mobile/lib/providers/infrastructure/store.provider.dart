import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/domain/services/store.service.dart';

final storeServiceProvider = Provider((_) => StoreService.I);
