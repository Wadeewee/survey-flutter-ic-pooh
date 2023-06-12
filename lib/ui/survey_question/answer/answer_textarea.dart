import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey_flutter_ic/extension/context_extension.dart';
import 'package:survey_flutter_ic/model/submit_survey_answer_model.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_model.dart';

class AnswerTextArea extends ConsumerWidget {
  final List<SurveyAnswerModel> answers;

  const AnswerTextArea({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var text = '';

    ref.listen(surveyNextQuestionsProvider, (_, displayType) {
      if (displayType.value == DisplayType.textarea) {
        ref.read(surveyQuestionsViewModelProvider.notifier).saveAnswer(
              SubmitSurveyAnswerModel(
                id: answers.first.id,
                answer: text,
              ),
            );
      }
    });

    return Center(
      child: TextField(
        style: const TextStyle(
          color: Colors.white,
          fontSize: fontSize17,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius10),
            borderSide: BorderSide.none,
          ),
          hintText: context.localization.survey_question_textarea_hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: fontSize17,
          ),
        ),
        cursorColor: Colors.white,
        textInputAction: TextInputAction.done,
        maxLines: 10,
        onChanged: (input) => text = input,
        onSubmitted: (input) => text = input,
      ),
    );
  }
}
