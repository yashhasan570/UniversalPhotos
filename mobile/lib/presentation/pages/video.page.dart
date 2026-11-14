import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/generated/translations.g.dart';
import 'package:universal_photos/presentation/widgets/timeline/timeline.widget.dart';
import 'package:universal_photos/providers/infrastructure/timeline.provider.dart';
import 'package:universal_photos/providers/user.provider.dart';
import 'package:universal_photos/widgets/common/mesmerizing_sliver_app_bar.dart';

@RoutePage()
class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        timelineServiceProvider.overrideWith((ref) {
          final user = ref.watch(currentUserProvider);
          if (user == null) {
            throw Exception('User must be logged in to video');
          }

          final timelineService = ref.watch(timelineFactoryProvider).video(user.id);
          ref.onDispose(timelineService.dispose);
          return timelineService;
        }),
      ],
      child: Timeline(appBar: MesmerizingSliverAppBar(title: context.t.videos)),
    );
  }
}
