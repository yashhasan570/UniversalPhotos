import 'package:pigeon/pigeon.dart';

enum PermissionStatus { granted, denied, permanentlyDenied }

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/platform/permission_api.g.dart',
    swiftOut: 'ios/Runner/Permission/PermissionApi.g.swift',
    swiftOptions: SwiftOptions(includeErrorClass: false),
    kotlinOut: 'android/app/src/main/kotlin/app/alextran/universalphotos/permission/PermissionApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'app.alextran.permission'),
    dartOptions: DartOptions(),
    dartPackageName: 'universal_photos',
  ),
)
@HostApi()
abstract class PermissionApi {
  PermissionStatus isIgnoringBatteryOptimizations();

  bool hasManageMediaPermission();

  @async
  bool requestManageMediaPermission();

  @async
  bool manageMediaPermission();
}
