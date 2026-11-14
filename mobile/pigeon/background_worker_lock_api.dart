import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/platform/background_worker_lock_api.g.dart',
    kotlinOut: 'android/app/src/main/kotlin/app/alextran/universalphotos/background/BackgroundWorkerLock.g.kt',
    kotlinOptions: KotlinOptions(package: 'app.alextran.background', includeErrorClass: false),
    dartOptions: DartOptions(),
    dartPackageName: 'universal_photos',
  ),
)
@HostApi()
abstract class BackgroundWorkerLockApi {
  void lock();

  void unlock();
}
