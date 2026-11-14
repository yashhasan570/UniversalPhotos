import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/domain/models/store.model.dart';
import 'package:universal_photos/domain/services/sync_linked_album.service.dart';
import 'package:universal_photos/entities/store.entity.dart';
import 'package:universal_photos/providers/infrastructure/cancel.provider.dart';
import 'package:logging/logging.dart';

Future<void> syncLinkedAlbumsIsolated(ProviderContainer ref) {
  final user = Store.tryGet(StoreKey.currentUser);
  if (user == null) {
    Logger("SyncLinkedAlbum").warning("No user logged in, skipping linked album sync");
    return Future.value();
  }
  return ref
      .read(syncLinkedAlbumServiceProvider)
      .syncLinkedAlbums(user.id, cancellation: ref.read(cancellationProvider));
}
