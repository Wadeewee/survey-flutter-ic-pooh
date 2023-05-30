import 'package:flutter/material.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/survey_question/answer/answer_dropdown.dart';

class SurveyQuestionItem extends StatelessWidget {
  final SurveyQuestionModel surveyQuestion;
  final Function(SurveyAnswerModel) onDropdownSelect;

  const SurveyQuestionItem({
    super.key,
    required this.surveyQuestion,
    required this.onDropdownSelect,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPageItem(surveyQuestion);
  }

  Widget _buildPageItem(SurveyQuestionModel surveyQuestion) {
    return Column(
      children: [
        _buildQuestionLabel(surveyQuestion.text),
        Expanded(
          // TODO: Handle widget to match with display type
          child: AnswerDropdown(
            answers: surveyQuestion.answers,
            onSelect: (result) => onDropdownSelect.call(result),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionLabel(String question) {
    return Text(
      question,
      style: const TextStyle(
        color: Colors.white,
        fontSize: fontSize34,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
