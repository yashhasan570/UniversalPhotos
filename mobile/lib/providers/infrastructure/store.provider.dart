import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos_mobile/domain/services/store.service.dart';

final storeServiceProvider = Provider((_) => StoreService.I);
