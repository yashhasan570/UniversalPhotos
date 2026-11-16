import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_photos_mobile/data/db/logger/database.dart';
import 'package:universal_photos_mobile/data/db/main/database.dart';
import 'package:universal_photos_mobile/domain/models/log.model.dart';
import 'package:universal_photos_mobile/infrastructure/repositories/log.repository.dart';
import 'package:universal_photos_mobile/services/universal_photos_logger.service.dart';

void main() {
  testWidgets('Shares the startup error and the stored logs before the log service starts', (tester) async {
    final dir = Directory.systemTemp.createTempSync('universal_photos-logs');
    addTearDown(() => dir.delete(recursive: true));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (_) async => dir.path,
    );
    late String shared;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/share'),
      (call) async {
        shared = File(((call.arguments as Map)['paths'] as List).single as String).readAsStringSync();
        return 'success';
      },
    );
    await tester.pumpWidget(const SizedBox());

    await tester.runAsync(() async {
      final logs = DriftLogger.sqlite(await openSqliteConnection(name: 'universal_photos_logs'));
      await LogRepository(logs).insertAll([
        LogMessage(
          message: 'Failed to connect to old.example.net/203.0.113.9:443, uri=https://old.example.net/api',
          level: LogLevel.warning,
          createdAt: DateTime(2026, 10, 15),
        ),
      ]);
      await logs.close();

      await UniversalPhotosLogger.shareLogs(
        tester.element(find.byType(SizedBox)),
        startupError: 'SqliteException(2067): UNIQUE constraint failed, parameters: 14, someone@example.com',
      );
    });

    expect(
      shared.split('\n').first,
      endsWith('| SqliteException(2067): UNIQUE constraint failed, parameters: 14, someone@example.com |'),
    );
    expect(
      shared,
      contains('| Failed to connect to old.example.net/203.0.113.9:443, uri=https://old.example.net/api |'),
    );
  });
}
