import 'package:drift/drift.dart';
import 'package:universal_photos/data/db/main/table/user/user.dart';
import 'package:universal_photos/data/db/util/defaults_mixin.dart';
import 'package:universal_photos/domain/models/user_metadata.model.dart';

class UserMetadataEntity extends Table with DriftDefaultsMixin {
  const UserMetadataEntity();

  TextColumn get userId => text().references(UserEntity, #id, onDelete: KeyAction.cascade)();

  IntColumn get key => intEnum<UserMetadataKey>()();

  BlobColumn get value => blob().map(userMetadataConverter)();

  @override
  Set<Column> get primaryKey => {userId, key};
}

final JsonTypeConverter2<Map<String, Object?>, Uint8List, Object?> userMetadataConverter = TypeConverter.jsonb(
  fromJson: (json) => json! as Map<String, Object?>,
);
