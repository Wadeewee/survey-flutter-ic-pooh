import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/ui/home/home_screen.dart';
import 'package:survey_flutter_ic/ui/survey_detail/survey_detail_widget_id.dart';

import 'fake_data/fake_data.dart';
import 'utils/test_util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  surveyDetailScreenTest();
}

void surveyDetailScreenTest() {
  group('SurveyDetail Page', () {
    late Finder backButton;
    late Finder coverImageUrl;
    late Finder titleText;
    late Finder descriptionText;
    late Finder startSurveyButton;

    const survey = SurveyModel(
      id: '1',
      title: 'Fake Survey Title',
      description: 'Fake Survey Description',
      isActive: true,
      coverImageUrl:
          'https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_',
      largeCoverImageUrl:
          'https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_l',
      createdAt: '2022-04-05T12:34:56Z',
      surveyType: 'Fake Survey Type',
    );

    const surveyWithCoverImageEmpty = SurveyModel(
      id: '1',
      title: 'Fake Survey Title',
      description: 'Fake Survey Description',
      isActive: true,
      coverImageUrl: '',
      largeCoverImageUrl: '',
      createdAt: '2022-04-05T12:34:56Z',
      surveyType: 'Fake Survey Type',
    );

    setUpAll(() async {
      await TestUtil.setupTestEnvironment();
    });

    setUp(() {
      backButton = find.byKey(SurveyDetailWidgetId.backButton);
      coverImageUrl = find.byKey(SurveyDetailWidgetId.coverImageUrl);
      titleText = find.byKey(SurveyDetailWidgetId.titleText);
      descriptionText = find.byKey(SurveyDetailWidgetId.descriptionText);
      startSurveyButton = find.byKey(SurveyDetailWidgetId.startSurveyButton);
    });

    testWidgets(
        "When setting survey successfully, it displays SurveyDetail screen correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_detail',
          extraBundle: survey,
        ),
      );
      await tester.pumpAndSettle();

      expect(backButton, findsOneWidget);
      expect(coverImageUrl, findsOneWidget);
      expect(titleText, findsOneWidget);
      expect(descriptionText, findsOneWidget);
      expect(startSurveyButton, findsOneWidget);
    });

    testWidgets(
        "When setting survey with CoverImageUrl is empty, it displays SurveyDetail screen correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_detail',
          extraBundle: surveyWithCoverImageEmpty,
        ),
      );
      await tester.pumpAndSettle();

      expect(coverImageUrl, findsNothing);

      expect(backButton, findsOneWidget);
      expect(titleText, findsOneWidget);
      expect(descriptionText, findsOneWidget);
      expect(startSurveyButton, findsOneWidget);
    });

    testWidgets(
        "When clicking on back button, it navigates back to Home screen",
        (WidgetTester tester) async {
      await FakeData.initDefault();
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_detail',
          extraBundle: survey,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(backButton);

      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
