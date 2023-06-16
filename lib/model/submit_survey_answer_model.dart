import 'package:equatable/equatable.dart';

class SubmitSurveyAnswerModel extends Equatable {
  final String id;
  final String answer;

  const SubmitSurveyAnswerModel({
    required this.id,
    required this.answer,
  });

  @override
  List<Object> get props => [id, answer];
}
