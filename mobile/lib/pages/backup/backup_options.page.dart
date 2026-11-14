import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/generated/translations.g.dart';
import 'package:universal_photos/infrastructure/repositories/settings.repository.dart';
import 'package:universal_photos/providers/background_sync.provider.dart';
import 'package:universal_photos/providers/backup/backup.provider.dart';
import 'package:universal_photos/providers/infrastructure/settings.provider.dart';
import 'package:universal_photos/providers/user.provider.dart';
import 'package:universal_photos/widgets/settings/backup_settings/backup_settings.dart';
import 'package:logging/logging.dart';

@RoutePage()
class BackupOptionsPage extends ConsumerWidget {
  const BackupOptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool hasPopped = false;
    final previousBackup = ref.watch(appConfigProvider.select((s) => s.backup));
    final previousCellularForVideos = previousBackup.useCellularForVideos;
    final previousCellularForPhotos = previousBackup.useCellularForPhotos;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        // There is an issue with Flutter where the pop event
        // can be triggered multiple times, so we guard it with _hasPopped

        final currentBackup = ref.read(appConfigProvider).backup;
        final currentCellularForVideos = currentBackup.useCellularForVideos;
        final currentCellularForPhotos = currentBackup.useCellularForPhotos;

        if (currentCellularForVideos == previousCellularForVideos &&
            currentCellularForPhotos == previousCellularForPhotos) {
          return;
        }

        if (didPop && !hasPopped) {
          hasPopped = true;

          final currentUser = ref.read(currentUserProvider);
          if (currentUser == null) {
            return;
          }

          await ref.read(backupProvider.notifier).getBackupStatus(currentUser.id);
          final isBackupEnabled = SettingsRepository.instance.appConfig.backup.enabled;
          if (!isBackupEnabled || !context.mounted) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.t.network_requirements_updated), duration: const Duration(seconds: 4)),
          );

          final backupNotifier = ref.read(backupProvider.notifier);
          final backgroundSync = ref.read(backgroundSyncProvider);
          backupNotifier.stopForegroundBackup(reason: "backup settings updated");
          unawaited(
            backgroundSync.syncRemote().then((success) {
              if (success) {
                return backupNotifier.startForegroundBackup(currentUser.id);
              } else {
                Logger('BackupOptionsPage').warning('Background sync failed, not starting backup');
              }
            }),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.t.backup_options)),
        body: const BackupSettings(),
      ),
    );
  }
}
