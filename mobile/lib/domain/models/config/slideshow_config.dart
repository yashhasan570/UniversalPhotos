import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:universal_photos/constants/enums.dart';

part 'slideshow_config.freezed.dart';

@freezed
abstract class SlideshowConfig with _$SlideshowConfig {
  const factory SlideshowConfig({
    @Default(true) bool repeat,
    @Default(5) int duration,
    @Default(SlideshowLook.blurredBackground) SlideshowLook look,
    @Default(SlideshowDirection.forward) SlideshowDirection direction,
  }) = _SlideshowConfig;
}
