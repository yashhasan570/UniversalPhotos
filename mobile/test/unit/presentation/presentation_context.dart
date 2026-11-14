import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos/constants/locales.dart';
import 'package:universal_photos/data/db/main/database.dart';
import 'package:universal_photos/data/server/tag.dart';
import 'package:universal_photos/domain/models/asset/base_asset.model.dart';
import 'package:universal_photos/domain/models/store.model.dart';
import 'package:universal_photos/domain/models/user.model.dart';
import 'package:universal_photos/domain/services/store.service.dart';
import 'package:universal_photos/generated/codegen_loader.g.dart';
import 'package:universal_photos/infrastructure/repositories/settings.repository.dart';
import 'package:universal_photos/infrastructure/repositories/store.repository.dart';
import 'package:universal_photos/presentation/actions/action.dart';
import 'package:universal_photos/presentation/actions/action.widget.dart';
import 'package:universal_photos/providers/infrastructure/album.provider.dart';
import 'package:universal_photos/providers/infrastructure/asset.provider.dart';
import 'package:universal_photos/providers/infrastructure/db.provider.dart';
import 'package:universal_photos/providers/infrastructure/user.provider.dart';
import 'package:universal_photos/providers/routes.provider.dart';
import 'package:universal_photos/providers/timeline/multiselect.provider.dart';
import 'package:universal_photos/providers/user.provider.dart';
import 'package:universal_photos/repositories/asset_media.repository.dart';
import 'package:universal_photos/repositories/permission.repository.dart';
import 'package:universal_photos/services/cleanup.service.dart';
import 'package:universal_photos/services/gcast.service.dart';
import 'package:universal_photos/services/server_info.service.dart';
import 'package:universalphotos_ui/universalphotos_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../infrastructure/repository.mock.dart';
import '../../test_utils.dart';
import '../factories/user_factory.dart';
import '../mocks.dart';

class PresentationContext {
  PresentationContext._({required UserDto user})
    : currentUser = user,
      service = ServiceMocks(),
      repository = RepositoryMocks() {
    setup();
  }

  static const String serverEndpoint = 'http://localhost:3000';

  static Drift? _db;

  final UserDto currentUser;
  final ServiceMocks service;
  final RepositoryMocks repository;

  List<Override> get overrides => [
    driftProvider.overrideWithValue(_mockDrift()),
    currentUserProvider.overrideWith((ref) => CurrentUserProvider(service.user.service)),
    userServiceProvider.overrideWithValue(service.user.service),
    assetServiceProvider.overrideWithValue(service.asset.service),
    cleanupServiceProvider.overrideWithValue(service.cleanup.service),
    remoteAlbumServiceProvider.overrideWithValue(service.album.service),
    partnerServiceProvider.overrideWithValue(service.partner.service),
    gCastServiceProvider.overrideWithValue(service.cast),
    serverInfoServiceProvider.overrideWithValue(service.serverInfo),
    inLockedViewProvider.overrideWithValue(false),
    assetMediaRepositoryProvider.overrideWithValue(repository.assetMedia.api),
    permissionRepositoryProvider.overrideWithValue(repository.permission.repo),
    tagApiRepositoryProvider.overrideWithValue(service.tag.repo),
  ];

  Drift _mockDrift() {
    final drift = MockDrift();
    when(() => drift.remoteAssetRepository).thenReturn(repository.remoteAsset.repo);
    return drift;
  }

  List<Override> selected(Set<BaseAsset> assets) => [
    multiSelectProvider.overrideWith(
      () => MultiSelectNotifier(MultiSelectState(selectedAssets: assets, lockedSelectionAssets: const {})),
    ),
  ];

  static Future<PresentationContext> create() async {
    TestUtils.init();
    if (_db == null) {
      final db = Drift(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
      await StoreService.init(storeRepository: StoreRepository(db), listenUpdates: false);
      await StoreService.I.put(StoreKey.serverEndpoint, serverEndpoint);
      _db = db;
    }
    await SettingsRepository.ensureInitialized(_db!);
    return PresentationContext._(user: UserFactory.createDto());
  }

  void setup() {
    when(service.user.tryGetMyUser).thenReturn(currentUser);

    // Handle system chrome messages
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => null,
    );
  }

  Future<void> dispose() async {
    await SettingsRepository.reset();
    service.resetAll();
  }
}

extension PumpPresentationWidget on WidgetTester {
  /// Renders the UI from the given [widget]
  ///
  /// Provide [expectSettle] `false` for a component that infinitely animates
  Future<void> pumpTestWidget(
    PresentationContext context,
    Widget widget, {
    List<Override> overrides = const [],
    bool expectSettle = true,
  }) async {
    await pumpWidget(
      EasyLocalization(
        supportedLocales: locales.values.toList(),
        path: translationsPath,
        startLocale: locales.values.first,
        fallbackLocale: locales.values.first,
        saveLocale: false,
        useFallbackTranslations: true,
        assetLoader: const CodegenLoader(),
        child: ProviderScope(
          overrides: context.overrides,
          child: Builder(
            builder: (context) => ProviderScope(
              overrides: overrides,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                scaffoldMessengerKey: scaffoldMessengerKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: Scaffold(body: widget),
              ),
            ),
          ),
        ),
      ),
    );

    if (expectSettle) {
      await pumpAndSettle();
    } else {
      await pump();
    }
  }

  Future<void> pumpTestAction(
    PresentationContext context,
    ActionBuilder action, {
    List<Override> overrides = const [],
  }) async {
    await pumpTestWidget(context, ActionIconButton(action: action), overrides: overrides);
    await tap(find.byType(UniversalPhotosIconButton));
    await pump();
  }

  Future<void> pumpUntilFound(Finder finder, {int maxFrames = 10}) async {
    for (var i = 0; i < maxFrames; i++) {
      await pump();
      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }
    throw StateError('pumpUntilFound: $finder not found within $maxFrames frames');
  }
}
