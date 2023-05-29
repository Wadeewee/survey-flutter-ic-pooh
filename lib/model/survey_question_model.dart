import 'package:equatable/equatable.dart';
import 'package:survey_flutter_ic/api/response/survey_question_response.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';

enum DisplayType {
  intro,
  star,
  heart,
  smiley,
  choice,
  nps,
  textarea,
  textfield,
  dropdown,
  outro,
  unknown,
}

class SurveyQuestionModel extends Equatable {
  final String id;
  final String text;
  final int displayOrder;
  final DisplayType displayType;
  final String coverImageUrl;
  final String largeCoverImageUrl;
  final double coverImageOpacity;
  final List<SurveyAnswerModel> answers;

  const SurveyQuestionModel({
    required this.id,
    required this.text,
    required this.displayOrder,
    required this.displayType,
    required this.coverImageOpacity,
    required this.coverImageUrl,
    required this.largeCoverImageUrl,
    required this.answers,
  });

  @override
  List<Object?> get props => [
        id,
        text,
        displayOrder,
        displayType,
        coverImageOpacity,
        coverImageUrl,
        largeCoverImageUrl,
        answers,
      ];

  factory SurveyQuestionModel.fromResponse(SurveyQuestionResponse response) {
    return SurveyQuestionModel(
      id: response.id,
      text: response.text ?? '',
      displayOrder: response.displayOrder ?? 0,
      displayType: DisplayType.values.firstWhere(
        (element) => element.name == response.displayType,
        orElse: () => DisplayType.unknown,
      ),
      coverImageOpacity: response.coverImageOpacity ?? 0.0,
      coverImageUrl: response.coverImageUrl ?? '',
      largeCoverImageUrl: '${response.coverImageUrl ?? ''}l',
      answers: (response.answers ?? [])
          .map((e) => SurveyAnswerModel.fromResponse(e))
          .toList(),
    );
  }
}
