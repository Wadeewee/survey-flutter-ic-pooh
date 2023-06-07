import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey_flutter_ic/model/submit_survey_answer_model.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_model.dart';

class AnswerForm extends ConsumerWidget {
  final List<SurveyAnswerModel> answers;

  const AnswerForm({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers =
        List.generate(answers.length, (_) => TextEditingController());

    ref.listen(surveyNextQuestionsProvider, (_, displayType) {
      if (displayType.value == DisplayType.textfield) {
        for (int index = 0; index < answers.length; index++) {
          ref.read(surveyQuestionsViewModelProvider.notifier).saveAnswer(
                SubmitSurveyAnswerModel(
                  id: answers[index].id,
                  answer: controllers[index].text,
                ),
              );
          controllers[index].clear();
        }
      }
    });

    return Center(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: answers.length,
        itemBuilder: (_, index) {
          return _buildTextFieldItem(index, controllers[index]);
        },
        separatorBuilder: (_, __) {
          return const SizedBox(height: space16);
        },
      ),
    );
  }

  Widget _buildTextFieldItem(
    int index,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
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
        hintText: answers[index].text,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: fontSize17,
        ),
      ),
      cursorColor: Colors.white,
      keyboardType: _getTextInputType(index),
      textInputAction: index == (answers.length - 1)
          ? TextInputAction.done
          : TextInputAction.next,
    );
  }

  TextInputType _getTextInputType(int index) {
    final text = answers[index].text.toLowerCase();

    if (text.contains('mobile') || text.contains('phone')) {
      return TextInputType.phone;
    } else if (text.contains('email')) {
      return TextInputType.emailAddress;
    } else if (text.contains('room')) {
      return TextInputType.number;
    } else {
      return TextInputType.text;
    }
  }
}
