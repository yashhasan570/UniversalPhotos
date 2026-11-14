import 'package:flutter_test/flutter_test.dart';
import 'package:universal_photos/generated/translations.g.dart';

import '../test_utils/general_helper.dart';

void main() async {
  await UniversalPhotosTestHelper.initialize();

  group("Login input validation test", () {
    universalphotosWidgetTest("Test leading/trailing whitespace", (tester, helper) async {
      await helper.loginHelper.waitForLoginScreen();
      await helper.loginHelper.acknowledgeNewServerVersion();

      await helper.loginHelper.enterCredentials(email: " demo@");

      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(StaticTranslations.instance.login_form_err_leading_whitespace), findsOneWidget);

      await helper.loginHelper.enterCredentials(email: "demo@ ");

      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(StaticTranslations.instance.login_form_err_trailing_whitespace), findsOneWidget);
    });

    universalphotosWidgetTest("Test invalid email", (tester, helper) async {
      await helper.loginHelper.waitForLoginScreen();
      await helper.loginHelper.acknowledgeNewServerVersion();

      await helper.loginHelper.enterCredentials(email: "demo.");

      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(StaticTranslations.instance.login_form_err_invalid_email), findsOneWidget);
    });
  });
}
