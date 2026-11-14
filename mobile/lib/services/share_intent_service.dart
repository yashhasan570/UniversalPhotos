import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/models/upload/share_intent_attachment.model.dart';
import 'package:universal_photos/repositories/share_handler.repository.dart';

final shareIntentServiceProvider = Provider((ref) => ShareIntentService(ref.watch(shareHandlerRepositoryProvider)));

class ShareIntentService {
  final ShareHandlerRepository shareHandlerRepository;
  void Function(List<ShareIntentAttachment> attachments)? onSharedMedia;

  ShareIntentService(this.shareHandlerRepository);

  void init() {
    shareHandlerRepository.onSharedMedia = onSharedMedia;
    unawaited(shareHandlerRepository.init());
  }
}
