import 'package:flutter/material.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/survey_question/answer/answer_dropdown.dart';
import 'package:survey_flutter_ic/ui/survey_question/answer/answer_emoji_rating.dart';
import 'package:survey_flutter_ic/ui/survey_question/answer/answer_form.dart';
import 'package:survey_flutter_ic/ui/survey_question/answer/answer_textarea.dart';

class SurveyQuestionItem extends StatelessWidget {
  final SurveyQuestionModel surveyQuestion;

  const SurveyQuestionItem({
    super.key,
    required this.surveyQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPageItem(surveyQuestion);
  }

  Widget _buildPageItem(SurveyQuestionModel surveyQuestion) {
    return Column(
      children: [
        if (surveyQuestion.answers.isNotEmpty)
          _buildQuestionLabel(surveyQuestion.text)
        else
          Expanded(
            child: SingleChildScrollView(
              child: _buildQuestionLabel(surveyQuestion.text),
            ),
          ),
        if (surveyQuestion.answers.isNotEmpty)
          Expanded(child: _buildAnswerItem())
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

  Widget _buildAnswerItem() {
    switch (surveyQuestion.displayType) {
      case DisplayType.dropdown:
        return AnswerDropdown(
          answers: surveyQuestion.answers,
        );
      case DisplayType.textarea:
        return AnswerTextArea(
          answers: surveyQuestion.answers,
        );
      case DisplayType.textfield:
        return AnswerForm(
          answers: surveyQuestion.answers,
        );
      case DisplayType.smiley:
      case DisplayType.star:
      case DisplayType.heart:
        return AnswerEmojiRating(
          displayType: surveyQuestion.displayType,
          answers: surveyQuestion.answers,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
