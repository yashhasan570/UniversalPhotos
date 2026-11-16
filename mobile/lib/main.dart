import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_photos_mobile/constants/constants.dart';
import 'package:universal_photos_mobile/constants/locales.dart';
import 'package:universal_photos_mobile/data/store.dart';
import 'package:universal_photos_mobile/domain/services/background_worker.service.dart';
import 'package:universal_photos_mobile/extensions/build_context_extensions.dart';
import 'package:universal_photos_mobile/generated/codegen_loader.g.dart';
import 'package:universal_photos_mobile/generated/translations.g.dart';
import 'package:universal_photos_mobile/infrastructure/repositories/network.repository.dart';
import 'package:universal_photos_mobile/pages/common/splash_screen.page.dart';
import 'package:universal_photos_mobile/platform/background_worker_lock_api.g.dart';
import 'package:universal_photos_mobile/platform/native_sync_api.g.dart';
import 'package:universal_photos_mobile/platform/permission_api.g.dart';
import 'package:universal_photos_mobile/providers/app_life_cycle.provider.dart';
import 'package:universal_photos_mobile/providers/asset_viewer/share_intent_upload.provider.dart';
import 'package:universal_photos_mobile/providers/infrastructure/platform.provider.dart';
import 'package:universal_photos_mobile/providers/infrastructure/settings.provider.dart';
import 'package:universal_photos_mobile/providers/locale_provider.dart';
import 'package:universal_photos_mobile/providers/routes.provider.dart';
import 'package:universal_photos_mobile/providers/theme.provider.dart';
import 'package:universal_photos_mobile/providers/view_intent/view_intent_handler.provider.dart';
import 'package:universal_photos_mobile/repositories/asset_media.repository.dart';
import 'package:universal_photos_mobile/routing/app_navigation_observer.dart';
import 'package:universal_photos_mobile/routing/router.dart';
import 'package:universal_photos_mobile/services/deep_link.service.dart';
import 'package:universal_photos_mobile/theme/dynamic_theme.dart';
import 'package:universal_photos_mobile/theme/theme_data.dart';
import 'package:universal_photos_mobile/utils/bootstrap.dart';
import 'package:universal_photos_mobile/utils/cache/widgets_binding.dart';
import 'package:universal_photos_mobile/utils/debug_print.dart';
import 'package:universal_photos_mobile/utils/fallback_localizations.dart';
import 'package:universal_photos_mobile/utils/licenses.dart';
import 'package:universal_photos_mobile/utils/migration.dart';
import 'package:universal_photos_mobile/wm_executor.dart';
import 'package:universal_photos_ui/universal_photos_ui.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:timezone/data/latest.dart';

void main() async {
  try {
    // https://github.com/flutter/flutter/issues/118384
    // Android only: Render maps into a TextureView
    // By default, MapLibre will embed them into platform views, using Virtual Display. For some reason Flutter has a bug
    // that leaks a presentation window and SurfaceFlinger layer for every map built, and it is never discarded
    MapLibreMap.useHybridComposition = true;

    UniversalPhotosWidgetsBinding();
    unawaited(BackgroundWorkerLockService(BackgroundWorkerLockApi()).lock());
    await EasyLocalization.ensureInitialized();
    final (dataController, apiService) = await Bootstrap.initDomain();
    await initApp();
    // Warm-up isolate pool for worker manager
    await workerManagerPatch.init(dynamicSpawning: true, isolatesCount: max(Platform.numberOfProcessors - 1, 5));
    await migrateDatabaseIfNeeded(dataController.db, NativeSyncApi(), PermissionApi());

    runApp(
      ProviderScope(
        overrides: Store.overrideWith(dataController: dataController, apiService: apiService),
        child: const MainWidget(),
      ),
    );
  } catch (error, stack) {
    Logger('main').severe('Failed to start', error, stack);
    runApp(BootstrapErrorWidget(error: error.toString(), stack: stack.toString()));
  }
}

Future<void> initApp() async {
  await initializeDateFormatting();

  if (Platform.isAndroid) {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
      dPrint(() => "Enabled high refresh mode");
    } catch (e) {
      dPrint(() => "Error setting high refresh rate: $e");
    }
  }

  await DynamicTheme.fetchSystemPalette();

  final log = Logger("UniversalPhotosErrorLogger");

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log.severe(
      'FlutterError - Catch all',
      "$details\nException: ${details.exception}\nLibrary: ${details.library}\nContext: ${details.context}",
      details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log.severe('PlatformDispatcher - Catch all', error, stack);
    return true;
  };

  initializeTimeZones();

  // Initialize the file downloader
  await FileDownloader().configure(
    // maxConcurrent: 6, maxConcurrentByHost(server):6, maxConcurrentByGroup: 3

    // On Android, if files are larger than 256MB, run in foreground service
    globalConfig: [(Config.holdingQueue, (6, 6, 3)), (Config.runInForegroundIfFileLargerThan, 256)],
  );

  await FileDownloader().trackTasksInGroup(kDownloadGroupLivePhoto, markDownloadedComplete: false);

  unawaited(FileDownloader().trackTasks());

  LicenseRegistry.addLicense(() async* {
    for (final license in nonPubLicenses.entries) {
      yield LicenseEntryWithLineBreaks([license.key], license.value);
    }
  });
}

class UniversalPhotosApp extends ConsumerStatefulWidget {
  const UniversalPhotosApp({super.key});

  @override
  UniversalPhotosAppState createState() => UniversalPhotosAppState();
}

class UniversalPhotosAppState extends ConsumerState<UniversalPhotosApp> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        dPrint(() => "[APP STATE] resumed");
        unawaited(ref.read(appStateProvider.notifier).handleAppResume());
        unawaited(ref.read(viewIntentHandlerProvider).onAppResumed());
      case AppLifecycleState.inactive:
        dPrint(() => "[APP STATE] inactive");
        ref.read(appStateProvider.notifier).handleAppInactivity();
      case AppLifecycleState.paused:
        dPrint(() => "[APP STATE] paused");
        unawaited(ref.read(appStateProvider.notifier).handleAppPause());
      case AppLifecycleState.detached:
        dPrint(() => "[APP STATE] detached");
        unawaited(ref.read(appStateProvider.notifier).handleAppDetached());
      case AppLifecycleState.hidden:
        dPrint(() => "[APP STATE] hidden");
        ref.read(appStateProvider.notifier).handleAppHidden();
    }
  }

  Future<void> initApp() async {
    WidgetsBinding.instance.addObserver(this);
    // Draw the app from edge to edge
    unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
    await _setNavigationBarColor();

    await FlutterLocalNotificationsPlugin().initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/notification_icon'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  Future<void> _setNavigationBarColor() async {
    SystemUiOverlayStyle overlayStyle = const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent);
    if (Platform.isAndroid) {
      // Android 8 does not support transparent app bars
      final info = await DeviceInfoPlugin().androidInfo;
      if (!mounted) {
        return;
      }

      if (info.version.sdkInt <= 26) {
        overlayStyle = context.isDarkTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
      }
    }
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  }

  Future<DeepLink> _deepLinkBuilder(PlatformDeepLink deepLink) async {
    final deepLinkHandler = ref.read(deepLinkServiceProvider);
    final currentRouteName = ref.read(currentRouteNameProvider.notifier).state;

    final isColdStart = currentRouteName == null || currentRouteName == SplashScreenRoute.name;

    PageRouteInfo? route;
    if (deepLink.uri.scheme == "universal_photos") {
      route = await deepLinkHandler.handleScheme(deepLink, ref);
    } else if (deepLink.uri.host == "my.") {
      route = await deepLinkHandler.handleMyUniversalPhotosApp(deepLink, ref);
    } else {
      return DeepLink.path(deepLink.path);
    }

    if (route == null) {
      return isColdStart ? DeepLink.defaultPath : DeepLink.none;
    }

    // We need to replace the route if the destination is the current route
    if (!isColdStart) {
      unawaited(
        ref.read(appRouterProvider).pushAndPopUntil(route, predicate: (r) => r.settings.name != route!.routeName),
      );
      return DeepLink.none;
    }

    if (deepLink.initial) {
      return DeepLink([SplashScreenRoute(deepLink: route)]);
    }

    return DeepLink([
      // we need something to segue back to if the app was cold started
      if (isColdStart) const TabShellRoute(children: [MainTimelineRoute()]),
      route,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Intl.defaultLocale = context.locale.toLanguageTag();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      configureFileDownloaderNotifications();
    });
  }

  @override
  void initState() {
    super.initState();
    unawaited(initApp().then((_) => dPrint(() => "App Init Completed")));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // needs to be delayed so that EasyLocalization is working
      unawaited(ref.read(backgroundWorkerFgServiceProvider).enable());
      if (Platform.isAndroid) {
        unawaited(
          ref
              .read(backgroundWorkerFgServiceProvider)
              .saveNotificationMessage(
                StaticTranslations.instance.uploading_media,
                StaticTranslations.instance.backup_background_service_default_notification,
              ),
        );
      }
    });

    ref.read(viewIntentHandlerProvider).init();
    ref.read(shareIntentUploadProvider.notifier).init();
    unawaited(ref.read(assetMediaRepositoryProvider).cleanupStaleShareFiles());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void reassemble() {
    if (kDebugMode) {
      unawaited(NetworkRepository.init());
    }
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final universal_photosTheme = ref.watch(universal_photosThemeProvider);

    return ProviderScope(
      overrides: [localeProvider.overrideWithValue(context.locale)],
      child: MaterialApp.router(
        title: 'UniversalPhotos',
        debugShowCheckedModeBanner: true,
        scaffoldMessengerKey: scaffoldMessengerKey,
        localizationsDelegates: [...context.localizationDelegates, ...fallbackLocalizationDelegates],
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        themeMode: ref.watch(appConfigProvider.select((config) => config.theme.mode)),
        darkTheme: getThemeData(colorScheme: universal_photosTheme.dark, locale: context.locale),
        theme: getThemeData(colorScheme: universal_photosTheme.light, locale: context.locale),
        builder: (context, child) => UniversalPhotosTranslationProvider(
          translations: UniversalPhotosTranslations(
            submit: context.t.submit,
            password: context.t.password,
            undo: context.t.undo,
          ),
          child: UniversalPhotosThemeProvider(colorScheme: context.colorScheme, child: child!),
        ),
        routerConfig: router.config(
          deepLinkBuilder: _deepLinkBuilder,
          navigatorObservers: () => [AppNavigationObserver(ref: ref), TransitioningRouteObserver()],
        ),
      ),
    );
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: locales.values.toList(),
      path: translationsPath,
      useFallbackTranslations: true,
      fallbackLocale: locales.values.first,
      assetLoader: const CodegenLoader(),
      child: const UniversalPhotosApp(),
    );
  }
}
