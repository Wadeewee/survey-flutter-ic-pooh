import 'package:json_annotation/json_annotation.dart';
import 'package:survey_flutter_ic/api/response/converter/response_converter.dart';
import 'package:survey_flutter_ic/api/response/survey_answer_response.dart';

part 'survey_question_response.g.dart';

@JsonSerializable()
class SurveyQuestionResponse {
  final String id;
  final String? text;
  final int? displayOrder;
  final String? displayType;
  final String? imageUrl;
  final String? coverImageUrl;
  final double? coverImageOpacity;
  final List<SurveyAnswerResponse> answers;

  SurveyQuestionResponse({
    required this.id,
    required this.text,
    required this.displayOrder,
    required this.displayType,
    required this.imageUrl,
    required this.coverImageUrl,
    required this.coverImageOpacity,
    required this.answers,
  });

  factory SurveyQuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$SurveyQuestionResponseFromJson(fromDataJsonApi(json));
}
