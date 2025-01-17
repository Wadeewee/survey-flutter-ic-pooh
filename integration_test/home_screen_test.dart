import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:survey_flutter_ic/navigation/route.dart';
import 'package:survey_flutter_ic/ui/home/home_widget_id.dart';
import 'package:survey_flutter_ic/ui/signin/sign_in_screen.dart';
import 'package:survey_flutter_ic/ui/survey_detail/survey_detail_screen.dart';

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
    late Finder signOutProfileName;
    late Finder signOutProfileAvatar;
    late Finder signOutDivider;
    late Finder signOutTextButton;

    setUpAll(() async {
      await TestUtil.setupTestEnvironment();
    });

    setUp(() async {
      profileAvatar = find.byKey(HomeWidgetId.profileAvatarImage);
      dateText = find.byKey(HomeWidgetId.dateText);
      todayText = find.byKey(HomeWidgetId.todayText);
      pagerIndicator = find.byKey(HomeWidgetId.pagerIndicator);
      coverImageUrl = find.byKey(HomeWidgetId.coverImageUrl);
      titleText = find.byKey(HomeWidgetId.titleText);
      descriptionText = find.byKey(HomeWidgetId.descriptionText);
      nextButton = find.byKey(HomeWidgetId.nextButton);
      signOutProfileName = find.byKey(HomeWidgetId.signOutProfileName);
      signOutProfileAvatar = find.byKey(HomeWidgetId.signOutProfileAvatar);
      signOutDivider = find.byKey(HomeWidgetId.signOutDivider);
      signOutTextButton = find.byKey(HomeWidgetId.signOutTextButton);

      await FakeData.initDefault();
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
        "When clicking on next button, it navigates to SurveyDetail screen",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(RoutePath.home.path),
      );

      await tester.pumpAndSettle();
      await tester.tap(nextButton);

      await tester.pumpAndSettle();
      expect(find.byType(SurveyDetailScreen), findsOneWidget);
    });

    testWidgets("When clicking on avatar, it display Drawer widget correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(RoutePath.home.path),
      );

      await tester.pumpAndSettle();
      await tester.tap(profileAvatar);

      await tester.pumpAndSettle();
      expect(signOutProfileName, findsOneWidget);
      expect(signOutProfileAvatar, findsOneWidget);
      expect(signOutDivider, findsOneWidget);
      expect(signOutTextButton, findsOneWidget);
    });

    testWidgets(
        "When clicking on logout text button, it display dialog correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(RoutePath.home.path),
      );

      await tester.pumpAndSettle();
      await tester.tap(profileAvatar);

      await tester.pumpAndSettle();
      await tester.tap(signOutTextButton);

      await tester.pumpAndSettle();
      expect(find.text('Confirmation'), findsOneWidget);
      expect(find.text('Are you sure you want to log out?'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets("When clicking on avatar, it display Drawer widget correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(RoutePath.home.path),
      );

      await tester.pumpAndSettle();
      await tester.tap(profileAvatar);

      await tester.pumpAndSettle();
      expect(signOutProfileName, findsOneWidget);
      expect(signOutProfileAvatar, findsOneWidget);
      expect(signOutDivider, findsOneWidget);
      expect(signOutTextButton, findsOneWidget);
    });

    testWidgets(
        "When clicking on logout text button, it display dialog correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(RoutePath.home.path),
      );

      await tester.pumpAndSettle();
      await tester.tap(profileAvatar);

      await tester.pumpAndSettle();
      await tester.tap(signOutTextButton);

      await tester.pumpAndSettle();
      expect(find.text('Confirmation'), findsOneWidget);
      expect(find.text('Are you sure you want to log out?'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets("When logout successfully, it navigates to SignIn screen",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(RoutePath.home.path),
      );

      await tester.pumpAndSettle();
      await tester.tap(profileAvatar);

      await tester.pumpAndSettle();
      await tester.tap(signOutTextButton);

      await tester.pumpAndSettle();
      await tester.tap(find.text('Log out'));

      await tester.pumpAndSettle();
      expect(find.byType(SignInScreen), findsOneWidget);
    });
  });
}
