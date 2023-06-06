import 'package:flutter/material.dart';
import 'package:survey_flutter_ic/extension/context_extension.dart';
import 'package:survey_flutter_ic/extension/toast_extension.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';

class AnswerTextArea extends StatelessWidget {
  final List<SurveyAnswerModel> answers;

  const AnswerTextArea({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
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
        onChanged: (input) => {
          // TODO: Trigger VM on Integration of submit task
        },
        onSubmitted: (input) => {
          // TODO: Trigger VM on Integration of submit task
          showToastMessage(input)
        },
      ),
    );
  }
}
