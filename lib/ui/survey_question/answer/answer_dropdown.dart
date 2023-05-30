import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';

class AnswerDropdown extends StatelessWidget {
  final List<SurveyAnswerModel> answers;
  final Function(SurveyAnswerModel) onSelect;

  const AnswerDropdown({
    super.key,
    required this.answers,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
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
          onSelect.call(answers[selected.first]);
        },
      ).makePicker(),
    );
  }
}
