import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/model/survey_detail_model.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_model.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_state.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';

import '../../mocks/generate_mocks.mocks.dart';

void main() {
  group('SurveyQuestionsViewModel', () {
    late MockGetSurveyDetailUseCase mockGetSurveyDetailUseCase;
    late MockSubmitSurveyUseCase mockSubmitSurveyUseCase;
    late SurveyQuestionsViewModel viewModel;
    late ProviderContainer container;

    const surveyDetail = SurveyDetailModel(
      id: "id",
      questions: <SurveyQuestionModel>[
        SurveyQuestionModel(
          id: "1",
          text: "text",
          displayOrder: 0,
          displayType: DisplayType.unknown,
          coverImageOpacity: 0.0,
          coverImageUrl: "coverImageUrl",
          largeCoverImageUrl: "largeCoverImageUrl",
          selectionType: SelectionType.none,
          answers: [],
        ),
      ],
    );

    setUp(() async {
      mockGetSurveyDetailUseCase = MockGetSurveyDetailUseCase();
      mockSubmitSurveyUseCase = MockSubmitSurveyUseCase();
      container = ProviderContainer(overrides: [
        surveyQuestionsViewModelProvider.overrideWith(
          (ref) => SurveyQuestionsViewModel(
            mockGetSurveyDetailUseCase,
            mockSubmitSurveyUseCase,
          ),
        )
      ]);
      viewModel = container.read(surveyQuestionsViewModelProvider.notifier);
      addTearDown(() => container.dispose());

      when(mockGetSurveyDetailUseCase.call(any))
          .thenAnswer((_) async => Success(surveyDetail));
      when(mockSubmitSurveyUseCase.call(any))
          .thenAnswer((_) async => Success(null));
    });

    test('When initializing SurveyQuestionsViewModel, its state is Init', () {
      expect(container.read(surveyQuestionsViewModelProvider),
          const SurveyQuestionsViewState.init());
    });

    test('When calling getSurveyDetail, it emits isLoading properly', () {
      expect(
        viewModel.isLoading,
        emitsInOrder([true, false]),
      );

      container
          .read(surveyQuestionsViewModelProvider.notifier)
          .getSurveyDetail("surveyId");
    });

    test('When calling getSurveyDetail successfully, it emits surveyQuestion',
        () {
      expect(
        viewModel.surveyQuestions,
        emitsThrough(surveyDetail.questions),
      );

      container
          .read(surveyQuestionsViewModelProvider.notifier)
          .getSurveyDetail("surveyId");
    });

    test('When calling getSurveyDetail failed, it returns the error state', () {
      when(mockGetSurveyDetailUseCase.call(any)).thenAnswer((_) async => Failed(
          UseCaseException(const NetworkExceptions.defaultError("Error"))));

      expect(
          viewModel.stream,
          emitsThrough(
            const SurveyQuestionsViewState.error("Error"),
          ));

      container
          .read(surveyQuestionsViewModelProvider.notifier)
          .getSurveyDetail("surveyId");
    });

    test(
        'When calling nextQuestion with the first index, it emits only currentIndex',
        () {
      expect(
        viewModel.currentIndex,
        emitsThrough(1),
      );

      expect(
        viewModel.surveyNextQuestions,
        neverEmits(null),
      );

      container.read(surveyQuestionsViewModelProvider.notifier).nextQuestion();
    });

    test(
        'When calling nextQuestion with the next index, it emits currentIndex and surveyNextQuestions',
        () async {
      expectLater(
        viewModel.currentIndex,
        emitsThrough(2),
      );

      expectLater(
        viewModel.surveyNextQuestions,
        emitsDone,
      );

      container.read(surveyQuestionsViewModelProvider.notifier).nextQuestion();
      container.read(surveyQuestionsViewModelProvider.notifier).nextQuestion();
    });

    test('When calling SubmitSurvey, it emits isLoading properly', () {
      expect(
        viewModel.isLoading,
        emitsInOrder([true, false]),
      );

      container
          .read(surveyQuestionsViewModelProvider.notifier)
          .submitSurvey("surveyId");
    });

    test(
        'When calling SubmitSurvey successfully, it returns navigateToCompletionScreen state',
        () {
      expect(
        viewModel.stream,
        emitsThrough(
          const SurveyQuestionsViewState.navigateToCompletionScreen(),
        ),
      );

      container
          .read(surveyQuestionsViewModelProvider.notifier)
          .submitSurvey("surveyId");
    });

    test('When calling SubmitSurvey failed, it returns the error state', () {
      when(mockSubmitSurveyUseCase.call(any)).thenAnswer((_) async => Failed(
          UseCaseException(const NetworkExceptions.defaultError("Error"))));

      expect(
        viewModel.stream,
        emitsThrough(const SurveyQuestionsViewState.error("Error")),
      );

      container
          .read(surveyQuestionsViewModelProvider.notifier)
          .submitSurvey("surveyId");
    });
  });
}
