import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/ui/survey_detail/survey_detail_view_model.dart';
import 'package:survey_flutter_ic/ui/survey_detail/survey_detail_view_state.dart';

void main() {
  group('SurveyDetailViewModel', () {
    late SurveyDetailViewModel viewModel;
    late ProviderContainer container;

    const survey = SurveyModel(
      id: 'id',
      title: 'title',
      description: 'description',
      isActive: true,
      coverImageUrl: 'coverImageUrl',
      largeCoverImageUrl: 'largeCoverImageUrl',
      createdAt: 'createdAt',
      surveyType: 'surveyType',
    );

    setUp(() {
      container = ProviderContainer(overrides: [
        surveyDetailViewModelProvider
            .overrideWith((ref) => SurveyDetailViewModel())
      ]);
      viewModel = container.read(surveyDetailViewModelProvider.notifier);
      addTearDown(() => container.dispose());
    });

    test('When initializing SurveyDetailViewModel, its state is Init', () {
      expect(container.read(surveyDetailViewModelProvider),
          const SurveyDetailViewState.init());
    });

    test('When setting survey, it emits survey', () {
      expect(
        viewModel.survey,
        emitsThrough(survey),
      );

      container.read(surveyDetailViewModelProvider.notifier).setSurvey(survey);
    });
  });
}
