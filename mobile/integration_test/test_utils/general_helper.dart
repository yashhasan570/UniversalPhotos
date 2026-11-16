import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos_mobile/data/store.dart';
// ignore: library_prefixes
import 'package:universal_photos_mobile/entities/store.entity.dart' as dbStore;
import 'package:universal_photos_mobile/main.dart' as app;
import 'package:universal_photos_mobile/utils/bootstrap.dart';
import 'package:integration_test/integration_test.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

import 'login_helper.dart';

class UniversalPhotosTestHelper {
  final WidgetTester tester;

  UniversalPhotosTestHelper(this.tester);

  UniversalPhotosTestLoginHelper? _loginHelper;

  UniversalPhotosTestLoginHelper get loginHelper {
    _loginHelper ??= UniversalPhotosTestLoginHelper(tester);
    return _loginHelper!;
  }

  static Future<IntegrationTestWidgetsFlutterBinding> initialize() async {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    // Load hive, localization...
    await app.initApp();

    return binding;
  }

  static Future<void> loadApp(WidgetTester tester) async {
    await EasyLocalization.ensureInitialized();
    // Clear all data from Isar (reuse existing instance if available)
    final (dataController, apiService) = await Bootstrap.initDomain();
    await dbStore.Store.clear();
    // Load main Widget
    await tester.pumpWidget(
      ProviderScope(
        overrides: Store.overrideWith(dataController: dataController, apiService: apiService),
        child: const app.MainWidget(),
      ),
    );
    // Post run tasks
    await EasyLocalization.ensureInitialized();
  }
}

@isTest
void universal_photosWidgetTest(String description, Future<void> Function(WidgetTester, UniversalPhotosTestHelper) test) {
  testWidgets(description, (widgetTester) async {
    await UniversalPhotosTestHelper.loadApp(widgetTester);
    await test(widgetTester, UniversalPhotosTestHelper(widgetTester));
  }, semanticsEnabled: false);
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 120),
}) async {
  bool found = false;
  final timer = Timer(timeout, () => throw TimeoutException("Pump until has timed out"));
  while (found != true) {
    await tester.pump();
    found = tester.any(finder);
  }
  timer.cancel();
}
