import 'package:universal_photos/domain/models/search_result.model.dart';
import 'package:universal_photos/extensions/asset_extensions.dart';
import 'package:universal_photos/extensions/string_extensions.dart';
import 'package:universal_photos/infrastructure/repositories/search_api.repository.dart';
import 'package:universal_photos/models/search/search_filter.model.dart';
import 'package:logging/logging.dart';

class SearchService {
  final _log = Logger("SearchService");
  final SearchApiRepository _searchApiRepository;

  SearchService(this._searchApiRepository);

  Future<SearchResult?> search(SearchFilter filter, int page) async {
    try {
      final response = await _searchApiRepository.search(filter, page);

      if (response == null || response.assets.items.isEmpty) {
        return null;
      }

      return SearchResult(
        assets: response.assets.items.map((e) => e.toDto()).toList(),
        nextPage: response.assets.nextPage?.toInt(),
      );
    } catch (error, stackTrace) {
      _log.severe("Failed to search for assets", error, stackTrace);
    }
    return null;
  }
}
