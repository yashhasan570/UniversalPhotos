import 'package:universal_photos/data/store.dart';

/// Direct API access for the repositories that have not yet been migrated to `Store`
// TODO(rewrite): Remove this provider once all repositories have migrated to `Store`
final apiServiceProvider = Store.api;
