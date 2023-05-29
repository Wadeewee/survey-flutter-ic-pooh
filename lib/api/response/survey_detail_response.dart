import 'package:json_annotation/json_annotation.dart';
import 'package:survey_flutter_ic/api/response/converter/response_converter.dart';
import 'package:survey_flutter_ic/api/response/survey_question_response.dart';

part 'survey_detail_response.g.dart';

@JsonSerializable()
class SurveyDetailResponse {
  final String id;
  final List<SurveyQuestionResponse>? questions;

  SurveyDetailResponse({
    required this.id,
    required this.questions,
  });

  factory SurveyDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$SurveyDetailResponseFromJson(fromDataJsonApi(json));
}
