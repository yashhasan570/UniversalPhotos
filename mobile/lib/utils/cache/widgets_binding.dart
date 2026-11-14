import 'package:flutter/widgets.dart';
import 'package:universal_photos/utils/cache/custom_image_cache.dart';

final class UniversalPhotosWidgetsBinding extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() => CustomImageCache();
}
