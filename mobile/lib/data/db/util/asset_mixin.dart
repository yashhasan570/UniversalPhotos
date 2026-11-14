// ignore_for_file: unused-code

import 'package:drift/drift.dart';
import 'package:universal_photos/data/db/util/datetime_clamp_type.dart';
import 'package:universal_photos/data/db/util/defaults_mixin.dart';
import 'package:universal_photos/domain/models/asset/base_asset.model.dart';

mixin AssetEntityMixin on DriftDefaultsMixin {
  TextColumn get name => text()();
  IntColumn get type => intEnum<AssetType>()();
  DateTimeColumn get createdAt => customType(clampedDateTime).withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => customType(clampedDateTime).withDefault(currentDateAndTime)();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  IntColumn get durationMs => integer().nullable()();
}
