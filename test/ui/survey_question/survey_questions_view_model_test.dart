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
    late SurveyQuestionsViewModel viewModel;
    late ProviderContainer container;

    const SurveyDetailModel surveyDetail = SurveyDetailModel(
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
          answers: [],
        ),
      ],
    );

    setUp(() async {
      mockGetSurveyDetailUseCase = MockGetSurveyDetailUseCase();
      container = ProviderContainer(overrides: [
        surveyQuestionsViewModelProvider
            .overrideWith((ref) => SurveyQuestionsViewModel(
                  mockGetSurveyDetailUseCase,
                ))
      ]);
      viewModel = container.read(surveyQuestionsViewModelProvider.notifier);
      addTearDown(() => container.dispose());

      when(mockGetSurveyDetailUseCase.call(any))
          .thenAnswer((_) async => Success(surveyDetail));
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

    test('When calling nextQuestion, it emits currentIndex', () {
      expect(
        viewModel.currentIndex,
        emitsThrough(1),
      );

      container.read(surveyQuestionsViewModelProvider.notifier).nextQuestion();
    });
  });
}
