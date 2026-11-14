import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/constants/enums.dart';
import 'package:universal_photos/generated/translations.g.dart';
import 'package:universal_photos/presentation/actions/action.dart';
import 'package:universal_photos/routing/router.dart';

final _stateProvider = Provider.family.autoDispose<List<String>?, ActionSource>((ref, source) {
  final assets = ref.watch(assetsActionProvider(source));
  final remoteIds = assets.remote().map((asset) => asset.id).toList(growable: false);
  return remoteIds.isEmpty ? null : remoteIds;
}, dependencies: [assetsActionProvider]);

class ShareLinkAction extends AssetActionBuilder {
  const ShareLinkAction({required super.source});

  @override
  ActionItem? create(BuildContext context, WidgetRef ref) {
    final remoteIds = ref.watch(_stateProvider(source));
    if (remoteIds == null) {
      return null;
    }

    return .new(
      icon: Icons.link_rounded,
      label: context.t.share_link,
      onAction: () async => unawaited(context.pushRoute(SharedLinkEditRoute(assetsList: remoteIds))),
    );
  }
}
