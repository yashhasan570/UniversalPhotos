import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:universal_photos/models/albums/album_search.model.dart';
import 'package:universal_photos/providers/album/album_sort_by_options.provider.dart';

part 'album_filter.utils.freezed.dart';

@freezed
abstract class AlbumFilter with _$AlbumFilter {
  const factory AlbumFilter({required QuickFilterMode mode, String? userId, String? query}) = _AlbumFilter;
}

@freezed
abstract class AlbumSort with _$AlbumSort {
  const factory AlbumSort({required AlbumSortMode mode, @Default(false) bool isReverse}) = _AlbumSort;
}
