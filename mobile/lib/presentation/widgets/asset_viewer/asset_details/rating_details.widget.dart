import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/constants/enums.dart';
import 'package:universal_photos/data/store.dart';
import 'package:universal_photos/domain/models/exif.model.dart';
import 'package:universal_photos/extensions/build_context_extensions.dart';
import 'package:universal_photos/extensions/theme_extensions.dart';
import 'package:universal_photos/generated/translations.g.dart';
import 'package:universal_photos/presentation/widgets/asset_viewer/rating_bar.widget.dart';
import 'package:universal_photos/providers/infrastructure/action.provider.dart';

class RatingDetails extends ConsumerWidget {
  final ExifInfo? exifInfo;

  const RatingDetails({super.key, this.exifInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRatingEnabled = ref
        .watch(Store.userMetadata.preferences())
        .maybeWhen(data: (prefs) => prefs?.ratingsEnabled ?? false, orElse: () => false);

    if (!isRatingEnabled) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            context.t.rating,
            style: context.textTheme.labelLarge?.copyWith(color: context.colorScheme.onSurfaceSecondary),
          ),
          RatingBar(
            initialRating: exifInfo?.rating?.toDouble() ?? 0,
            filledColor: context.themeData.colorScheme.primary,
            unfilledColor: context.themeData.colorScheme.onSurface.withAlpha(100),
            itemSize: 40,
            onRatingUpdate: (rating) async {
              await ref.read(actionProvider.notifier).updateRating(ActionSource.viewer, rating);
            },
            onClearRating: () async {
              await ref.read(actionProvider.notifier).updateRating(ActionSource.viewer, null);
            },
          ),
        ],
      ),
    );
  }
}
