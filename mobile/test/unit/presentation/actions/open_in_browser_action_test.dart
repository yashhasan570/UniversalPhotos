import 'package:flutter_test/flutter_test.dart';
import 'package:universal_photos_mobile/domain/services/timeline.service.dart';
import 'package:universal_photos_mobile/presentation/actions/action.widget.dart';
import 'package:universal_photos_mobile/presentation/actions/open_in_browser.action.dart';
import 'package:universal_photos_ui/universal_photos_ui.dart';

import '../presentation_context.dart';

void main() {
  late PresentationContext context;

  setUp(() async {
    context = await PresentationContext.create();
  });

  tearDown(() async {
    await context.dispose();
  });

  group('webPathFor', () {
    const dedicatedPages = {
      TimelineOrigin.favorite: '/favorites',
      TimelineOrigin.trash: '/trash',
      TimelineOrigin.archive: '/archive',
    };

    for (final origin in TimelineOrigin.values) {
      final expected = dedicatedPages[origin] ?? '';

      test('opens ${origin.name} on ${expected.isEmpty ? 'the main timeline' : expected}', () {
        expect(webPathFor(origin), expected);
      });
    }
  });

  group('OpenInBrowserAction', () {
    testWidgets('always renders, since the kebab menu decides whether to offer it', (tester) async {
      await tester.pumpTestWidget(
        context,
        const ActionIconButton(
          action: OpenInBrowserAction(remoteId: 'remote-1', origin: .main),
        ),
      );

      expect(find.byType(UniversalPhotosIconButton), findsOneWidget);
    });
  });
}
