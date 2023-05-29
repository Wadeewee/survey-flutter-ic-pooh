import 'package:json_annotation/json_annotation.dart';
import 'package:survey_flutter_ic/api/response/converter/response_converter.dart';

part 'survey_answer_response.g.dart';

@JsonSerializable()
class SurveyAnswerResponse {
  final String id;
  final String? text;
  final int? displayOrder;
  final String? displayType;

  SurveyAnswerResponse({
    required this.id,
    required this.text,
    required this.displayOrder,
    required this.displayType,
  });

  factory SurveyAnswerResponse.fromJson(Map<String, dynamic> json) =>
      _$SurveyAnswerResponseFromJson(fromDataJsonApi(json));
}
