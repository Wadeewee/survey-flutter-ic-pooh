import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_detail_view_state.freezed.dart';

@freezed
class SurveyDetailViewState with _$SurveyDetailViewState {
  const factory SurveyDetailViewState.init() = _Init;
}
