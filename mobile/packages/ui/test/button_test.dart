import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_photos_ui/src/components/column_button.dart';
import 'package:universal_photos_ui/src/components/icon_button.dart';
import 'package:universal_photos_ui/src/components/text_button.dart';

import 'test_utils.dart';

void main() {
  Future<void> tapTwiceInOneFrame(WidgetTester tester, Widget Function(Future<void> Function() onPressed) build) async {
    var runs = 0;
    final action = Completer<void>();
    final button = build(() {
      runs++;
      return action.future;
    });
    await tester.pumpTestWidget(button);

    await tester.tap(find.byWidget(button));
    await tester.tap(find.byWidget(button));
    expect(runs, 1);

    action.complete();
    await tester.pump();
    await tester.tap(find.byWidget(button));
    expect(runs, 2);
  }

  testWidgets('UniversalPhotosTextButton runs its action once for two taps in one frame', (tester) async {
    await tapTwiceInOneFrame(tester, (onPressed) => UniversalPhotosTextButton(labelText: 'Save', onPressed: onPressed));
  });

  testWidgets('UniversalPhotosIconButton runs its action once for two taps in one frame', (tester) async {
    await tapTwiceInOneFrame(tester, (onPressed) => UniversalPhotosIconButton(icon: Icons.add, onPressed: onPressed));
  });

  testWidgets('UniversalPhotosColumnButton runs its action once for two taps in one frame', (tester) async {
    await tapTwiceInOneFrame(
      tester,
      (onPressed) => UniversalPhotosColumnButton(icon: Icons.share, label: 'Share', onPressed: onPressed),
    );
  });
}
