import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:survey_flutter_ic/ui/survey_completion/survey_completion_screen.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_question_id.dart';

import 'fake_data/fake_data.dart';
import 'utils/test_util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  surveyQuestionScreenTest();
}

void surveyQuestionScreenTest() {
  group('SurveyQuestion Page', () {
    late Finder questionsIndicator;
    late Finder coverImageUrl;
    late Finder questionLabel;
    late Finder closeButton;
    late Finder answerNps;
    late Finder answerTextarea;
    late Finder answerForm;
    late Finder answerEmojiRating;
    late Finder answerMultipleChoices;
    late Finder answerDropdown;
    late Finder nextQuestionButton;
    late Finder submitButton;

    setUpAll(() async {
      await TestUtil.setupTestEnvironment();
    });

    setUp(() async {
      questionsIndicator =
          find.byKey(SurveyQuestionWidgetId.questionsIndicator);
      coverImageUrl = find.byKey(SurveyQuestionWidgetId.coverImageUrl);
      questionLabel = find.byKey(SurveyQuestionWidgetId.questionLabel);
      closeButton = find.byKey(SurveyQuestionWidgetId.closeButton);
      answerNps = find.byKey(SurveyQuestionWidgetId.answerNps);
      answerTextarea = find.byKey(SurveyQuestionWidgetId.answerTextarea);
      answerForm = find.byKey(SurveyQuestionWidgetId.answerForm);
      answerEmojiRating = find.byKey(SurveyQuestionWidgetId.answerEmojiRating);
      answerMultipleChoices =
          find.byKey(SurveyQuestionWidgetId.answerMultipleChoices);
      answerDropdown = find.byKey(SurveyQuestionWidgetId.answerDropdown);
      nextQuestionButton =
          find.byKey(SurveyQuestionWidgetId.nextQuestionButton);
      submitButton = find.byKey(SurveyQuestionWidgetId.submitButton);

      await FakeData.initDefault();
    });

    Future goToPage(
      WidgetTester tester,
      int page,
    ) async {
      for (int index = 0; index < (page - 1); index++) {
        await tester.tap(nextQuestionButton);
      }
    }

    testWidgets(
        "When getSurveyDetail failed, it displays SurveyQuestion screen correctly",
        (WidgetTester tester) async {
      FakeData.updateResponse(
        keySurveyDetail,
        const FakeResponseModel(400, {}),
      );
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_questions/ed1d4f0ff19a56073a14',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(questionsIndicator, findsNothing);
      expect(coverImageUrl, findsNothing);
      expect(questionLabel, findsNothing);
      expect(closeButton, findsNothing);
      expect(nextQuestionButton, findsNothing);
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Bad request'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
    });

    testWidgets(
        "When getSurveyDetail successfully, it displays SurveyQuestion screen correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_questions/ed1d4f0ff19a56073a14',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(questionsIndicator, findsOneWidget);
      expect(coverImageUrl, findsOneWidget);
      expect(questionLabel, findsOneWidget);
      expect(closeButton, findsOneWidget);
      expect(nextQuestionButton, findsOneWidget);
    });

    testWidgets(
        "When go to the second page with answer type is MultipleChoices, it displays SurveyQuestion screen correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_questions/ed1d4f0ff19a56073a14',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await goToPage(tester, 2);
      await tester.pumpAndSettle();

      expect(answerMultipleChoices, findsOneWidget);
    });

    testWidgets(
        "When go to the fourth page with answer type is Nps, it displays SurveyQuestion screen correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_questions/ed1d4f0ff19a56073a14',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await goToPage(tester, 4);
      await tester.pumpAndSettle();

      expect(answerNps, findsOneWidget);
    });

    testWidgets(
        "When go to the fifth page with answer type is EmojiRating, it displays SurveyQuestion screen correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_questions/ed1d4f0ff19a56073a14',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await goToPage(tester, 5);
      await tester.pumpAndSettle();

      expect(answerEmojiRating, findsOneWidget);
    });

    testWidgets(
        "When go to the ninth page with answer type is Textarea, it displays SurveyQuestion screen correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_questions/ed1d4f0ff19a56073a14',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await goToPage(tester, 9);
      await tester.pumpAndSettle();

      expect(answerTextarea, findsOneWidget);
    });

    testWidgets(
        "When go to the tenth page with answer type is Dropdown, it displays SurveyQuestion screen correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_questions/ed1d4f0ff19a56073a14',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await goToPage(tester, 10);
      await tester.pumpAndSettle();

      expect(answerDropdown, findsOneWidget);
    });

    testWidgets(
        "When go to the eleventh page with answer type is Form, it displays SurveyQuestion screen correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_questions/ed1d4f0ff19a56073a14',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await goToPage(tester, 11);
      await tester.pumpAndSettle();

      expect(answerForm, findsOneWidget);
    });

    testWidgets("When tapping on close button, it displays dialog correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_questions/ed1d4f0ff19a56073a14',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      expect(find.text('Warning!'), findsOneWidget);
      expect(
        find.text('Are you sure you want to quit the survey?'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
    });

    testWidgets("When submitSurvey failed, it displays dialog correctly",
        (WidgetTester tester) async {
      FakeData.updateResponse(
        keySurveySubmit,
        const FakeResponseModel(400, {}),
      );
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_questions/ed1d4f0ff19a56073a14',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await goToPage(tester, 12);
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(submitButton, findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Bad request'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
    });

    testWidgets(
        "When submitSurvey successfully, it navigates to SurveyCompletion screen",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtil.pumpWidgetWithRoutePath(
          '/home/survey_questions/ed1d4f0ff19a56073a14',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await goToPage(tester, 12);
      await tester.pumpAndSettle();
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(find.byType(SurveyCompletionScreen), findsOneWidget);
    });
  });
}
