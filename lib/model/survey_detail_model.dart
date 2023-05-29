import 'package:equatable/equatable.dart';
import 'package:survey_flutter_ic/api/response/survey_detail_response.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';

class SurveyDetailModel extends Equatable {
  final String id;
  final List<SurveyQuestionModel> questions;

  const SurveyDetailModel({
    required this.id,
    required this.questions,
  });

  @override
  List<Object?> get props => [id, questions];

  factory SurveyDetailModel.fromResponse(SurveyDetailResponse response) {
    return SurveyDetailModel(
        id: response.id,
        questions: (response.questions ?? [])
            .map((e) => SurveyQuestionModel.fromResponse(e))
            .toList());
  }
}
