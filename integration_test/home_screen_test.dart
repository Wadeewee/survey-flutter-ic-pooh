import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:survey_flutter_ic/navigation/route.dart';
import 'package:survey_flutter_ic/ui/home/home_widget_id.dart';

import 'fake_data/fake_data.dart';
import 'utils/test_util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  homeScreenTest();
}

void homeScreenTest() {
  group('Home Page', () {
    late Finder profileAvatar;
    late Finder dateText;
    late Finder todayText;
    late Finder pagerIndicator;
    late Finder coverImageUrl;
    late Finder titleText;
    late Finder descriptionText;
    late Finder nextButton;

    setUpAll(() async {
      await TestUtil.setupTestEnvironment();
      await FakeData.initDefault();
    });

    setUp(() {
      profileAvatar = find.byKey(HomeWidgetId.profileAvatarImage);
      dateText = find.byKey(HomeWidgetId.dateText);
      todayText = find.byKey(HomeWidgetId.todayText);
      pagerIndicator = find.byKey(HomeWidgetId.pagerIndicator);
      coverImageUrl = find.byKey(HomeWidgetId.coverImageUrl);
      titleText = find.byKey(HomeWidgetId.titleText);
      descriptionText = find.byKey(HomeWidgetId.descriptionText);
      nextButton = find.byKey(HomeWidgetId.nextButton);
    });

    testWidgets(
        "When loading data successfully, it displays Home screen correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(RoutePath.home.path),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(profileAvatar, findsOneWidget);
      expect(dateText, findsOneWidget);
      expect(todayText, findsOneWidget);
      expect(pagerIndicator, findsOneWidget);
      expect(coverImageUrl, findsOneWidget);
      expect(titleText, findsOneWidget);
      expect(descriptionText, findsOneWidget);
      expect(nextButton, findsOneWidget);
    });

    testWidgets(
        "When loading data and getProfile failed, it displays Home screen correctly",
        (WidgetTester tester) async {
      FakeData.updateResponse(keyUserProfile, const FakeResponseModel(400, {}));
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(RoutePath.home.path),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(profileAvatar, findsOneWidget);
      expect(dateText, findsOneWidget);
      expect(todayText, findsOneWidget);
      expect(pagerIndicator, findsOneWidget);
      expect(coverImageUrl, findsOneWidget);
      expect(titleText, findsOneWidget);
      expect(descriptionText, findsOneWidget);
      expect(nextButton, findsOneWidget);
    });

    testWidgets(
        "When loading data and getSurveys failed, it displays Home screen correctly",
        (WidgetTester tester) async {
      FakeData.updateResponse(keySurveys, const FakeResponseModel(400, {}));
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(RoutePath.home.path),
      );
      await tester.pumpAndSettle();

      expect(profileAvatar, findsOneWidget);
      expect(dateText, findsOneWidget);
      expect(todayText, findsOneWidget);

      expect(pagerIndicator, findsNothing);
      expect(coverImageUrl, findsNothing);
      expect(titleText, findsNothing);
      expect(descriptionText, findsNothing);
      expect(nextButton, findsNothing);
    });
  });
}
