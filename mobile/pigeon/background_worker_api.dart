import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/platform/background_worker_api.g.dart',
    swiftOut: 'ios/Runner/Background/BackgroundWorker.g.swift',
    swiftOptions: SwiftOptions(includeErrorClass: false),
    kotlinOut: 'android/app/src/main/kotlin/app/alextran/universal_photos/background/BackgroundWorker.g.kt',
    kotlinOptions: KotlinOptions(package: 'app.alextran.universal_photos.background'),
    dartOptions: DartOptions(),
    dartPackageName: 'universal_photos_mobile',
  ),
)
class BackgroundWorkerSettings {
  final bool requiresCharging;
  final int minimumDelaySeconds;

  const BackgroundWorkerSettings({required this.requiresCharging, required this.minimumDelaySeconds});
}

@HostApi()
abstract class BackgroundWorkerFgHostApi {
  void enable();

  void saveNotificationMessage(String title, String body);

  void configure(BackgroundWorkerSettings settings);

  void disable();

  // iOS Only: true when the OS started the process in the background for one of its background tasks
  bool wasLaunchedInBackground();
}

@HostApi()
abstract class BackgroundWorkerBgHostApi {
  // Called from the background flutter engine when it has bootstrapped and established the
  // required platform channels to notify the native side to start the background upload
  void onInitialized();

  // Called from the background flutter engine to request the native side to cleanup
  void close();
}

@FlutterApi()
abstract class BackgroundWorkerFlutterApi {
  // iOS Only: Called when the iOS background upload is triggered
  @async
  void onIosUpload(bool isRefresh, int? maxSeconds);

  // Android Only: Called when the Android background upload is triggered
  // Returns whether the native side needs to retry the run
  @async
  bool onAndroidUpload(int? maxMinutes);

  @async
  void cancel();
}
