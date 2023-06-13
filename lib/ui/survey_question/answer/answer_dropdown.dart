import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey_flutter_ic/model/submit_survey_answer_model.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_model.dart';

class AnswerDropdown extends ConsumerWidget {
  final List<SurveyAnswerModel> answers;

  const AnswerDropdown({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedAnswerIndex = 0;

    ref.listen(surveyNextQuestionsProvider, (_, __) {
      ref.read(surveyQuestionsViewModelProvider.notifier).saveAnswer(
            SubmitSurveyAnswerModel(
              id: answers[selectedAnswerIndex].id,
              answer: answers[selectedAnswerIndex].text,
            ),
          );
    });

    return Center(
      child: Picker(
        adapter: PickerDataAdapter<String>(
          pickerData: answers.map((answer) => answer.text).toList(),
        ),
        textStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: fontSize20,
          fontWeight: FontWeight.w400,
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: fontSize20,
          fontWeight: FontWeight.w800,
        ),
        selectionOverlay: const DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: dropdownItemDividerHeight,
                color: Colors.white,
              ),
              bottom: BorderSide(
                width: dropdownItemDividerHeight,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        containerColor: Colors.transparent,
        itemExtent: dropdownItemHeight,
        hideHeader: true,
        onSelect: (picker, index, selected) {
          selectedAnswerIndex = selected.first;
        },
      ).makePicker(),
    );
  }
}
