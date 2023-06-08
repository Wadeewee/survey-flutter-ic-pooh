import 'package:equatable/equatable.dart';
import 'package:survey_flutter_ic/model/submit_survey_answer_model.dart';

class SubmitSurveyQuestionModel extends Equatable {
  final String id;
  final List<SubmitSurveyAnswerModel> answers;

  const SubmitSurveyQuestionModel({
    required this.id,
    required this.answers,
  });

  @override
  List<Object> get props => [id, answers];
}
