import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:survey_flutter_ic/model/submit_survey_answer_model.dart';

part 'submit_survey_answer_request.g.dart';

@JsonSerializable()
class SubmitSurveyAnswerRequest {
  final String id;
  final String answer;

  SubmitSurveyAnswerRequest({
    required this.id,
    required this.answer,
  });

  factory SubmitSurveyAnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitSurveyAnswerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitSurveyAnswerRequestToJson(this);

  factory SubmitSurveyAnswerRequest.fromModel(SubmitSurveyAnswerModel model) {
    return SubmitSurveyAnswerRequest(
      id: model.id,
      answer: model.answer,
    );
  }
}
