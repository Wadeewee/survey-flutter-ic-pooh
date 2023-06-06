import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:survey_flutter_ic/navigation/route.dart';
import 'package:survey_flutter_ic/ui/home/home_screen.dart';
import 'package:survey_flutter_ic/ui/signin/sign_in_screen.dart';
import 'package:survey_flutter_ic/ui/splash/splash_widget_id.dart';

import 'fake_data/fake_data.dart';
import 'utils/test_util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  splashScreenTest();
}

void splashScreenTest() {
  group('Splash Page', () {
    late Finder background;
    late Finder logo;

    setUpAll(() async {
      await TestUtil.setupTestEnvironment();
    });

    setUp(() {
      background = find.byKey(SplashWidgetId.background);
      logo = find.byKey(SplashWidgetId.logo);
    });

    testWidgets(
        "When entering SplashScreen with signed-in, it navigates to Home screen",
        (WidgetTester tester) async {
      FlutterSecureStorage.setMockInitialValues({
        'KEY_ACCESS_TOKEN': 'accessToken',
      });
      await FakeData.initDefault();
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(RoutePath.root.path),
      );

      await tester.pumpAndSettle();
      expect(background, findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500));
      expect(logo, findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets(
        "When entering SplashScreen with not signed-in, it navigates to SignIn screen",
        (WidgetTester tester) async {
      FlutterSecureStorage.setMockInitialValues({'KEY_ACCESS_TOKEN': ''});
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(RoutePath.root.path),
      );

      await tester.pumpAndSettle();
      expect(background, findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500));
      expect(logo, findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(SignInScreen), findsOneWidget);
    });
  });
}
