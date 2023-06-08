import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:survey_flutter_ic/api/request/submit_survey_answer_request.dart';
import 'package:survey_flutter_ic/model/submit_survey_question_model.dart';

part 'submit_survey_question_request.g.dart';

@JsonSerializable()
class SubmitSurveyQuestionRequest {
  final String id;
  final List<SubmitSurveyAnswerRequest> answers;

  SubmitSurveyQuestionRequest({
    required this.id,
    required this.answers,
  });

  factory SubmitSurveyQuestionRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitSurveyQuestionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitSurveyQuestionRequestToJson(this);

  factory SubmitSurveyQuestionRequest.fromModel(
    SubmitSurveyQuestionModel model,
  ) {
    return SubmitSurveyQuestionRequest(
      id: model.id,
      answers: model.answers
          .map((answer) => SubmitSurveyAnswerRequest.fromModel(answer))
          .toList(),
    );
  }
}
