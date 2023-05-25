import 'package:equatable/equatable.dart';
import 'package:survey_flutter_ic/api/response/survey_answer_response.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';

class SurveyAnswerModel extends Equatable {
  final String id;
  final String text;
  final int displayOrder;
  final DisplayType displayType;

  const SurveyAnswerModel({
    required this.id,
    required this.text,
    required this.displayOrder,
    required this.displayType,
  });

  @override
  List<Object?> get props => [
        id,
        text,
        displayOrder,
        displayType,
      ];

  factory SurveyAnswerModel.fromResponse(SurveyAnswerResponse response) {
    return SurveyAnswerModel(
      id: response.id,
      text: response.text ?? '',
      displayOrder: response.displayOrder ?? 0,
      displayType: DisplayType.values.firstWhere(
        (element) => element.name == response.displayType,
        orElse: () => DisplayType.unknown,
      ),
    );
  }
}
