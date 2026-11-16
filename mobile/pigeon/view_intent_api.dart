import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/platform/view_intent_api.g.dart',
    kotlinOut: 'android/app/src/main/kotlin/app/alextran/universal_photos/viewintent/ViewIntent.g.kt',
    kotlinOptions: KotlinOptions(package: 'app.alextran.universal_photos.viewintent'),
    dartOptions: DartOptions(),
    dartPackageName: 'universal_photos_mobile',
  ),
)
class ViewIntentPayload {
  final String? path;
  final String mimeType;
  final String? localAssetId;

  const ViewIntentPayload({this.path, required this.mimeType, this.localAssetId});
}

@HostApi()
abstract class ViewIntentHostApi {
  @async
  ViewIntentPayload? consumeViewIntent();
}
