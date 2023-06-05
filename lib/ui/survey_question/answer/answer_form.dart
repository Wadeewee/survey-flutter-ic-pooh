import 'package:flutter/material.dart';
import 'package:survey_flutter_ic/extension/toast_extension.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';

class AnswerForm extends StatelessWidget {
  final List<SurveyAnswerModel> answers;

  const AnswerForm({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: answers.length,
        itemBuilder: (_, index) {
          return _buildTextFieldItem(index);
        },
        separatorBuilder: (_, __) {
          return const SizedBox(height: space16);
        },
      ),
    );
  }

  Widget _buildTextFieldItem(int index) {
    return TextField(
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
      onChanged: (input) {
        // TODO: Trigger VM on Integration of submit task
      },
      onSubmitted: (input) {
        // TODO: Trigger VM on Integration of submit task
        showToastMessage(input);
      },
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
