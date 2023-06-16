import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_questions_view_state.freezed.dart';

@freezed
class SurveyQuestionsViewState with _$SurveyQuestionsViewState {
  const factory SurveyQuestionsViewState.init() = _Init;

  const factory SurveyQuestionsViewState.navigateToCompletionScreen() =
      _NavigateToCompletionScreen;

  const factory SurveyQuestionsViewState.error(String message) = _Error;
}
