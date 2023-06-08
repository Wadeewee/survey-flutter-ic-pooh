import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';

const _defaultSelectedChoiceIndex = -1;

final selectedChoicesIndexProvider = StateProvider.autoDispose<List<int>>(
    (_) => <int>[_defaultSelectedChoiceIndex]);

class AnswerMultipleChoices extends ConsumerWidget {
  final List<SurveyAnswerModel> answers;
  final SelectionType selectionType;

  const AnswerMultipleChoices({
    super.key,
    required this.answers,
    required this.selectionType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndexes = ref.watch(selectedChoicesIndexProvider);

    return Center(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: answers.length,
        itemBuilder: (_, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  answers[index].text,
                  style: TextStyle(
                    color: selectedIndexes.contains(index)
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    fontSize: fontSize20,
                    fontWeight: selectedIndexes.contains(index)
                        ? FontWeight.w800
                        : FontWeight.w400,
                  ),
                ),
              ),
              Checkbox(
                shape: const CircleBorder(),
                side: BorderSide(
                  color: selectedIndexes.contains(index)
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                activeColor: Colors.white,
                checkColor: Colors.black,
                value: selectedIndexes.contains(index),
                onChanged: (bool? isSelected) {
                  _handleAnswerSelection(
                    ref,
                    selectedIndexes,
                    index,
                    isSelected,
                  );
                },
              )
            ],
          );
        },
        separatorBuilder: (_, __) {
          return const Divider(
            thickness: 0.5,
            color: Colors.white,
          );
        },
      ),
    );
  }

  void _handleAnswerSelection(
    WidgetRef ref,
    List<int> selectedIndexes,
    int index,
    bool? isSelected,
  ) {
    final newSelectedChoicesIndex = List<int>.from(selectedIndexes);

    if (selectionType == SelectionType.one) {
      newSelectedChoicesIndex.clear();
    }

    if (isSelected == true) {
      newSelectedChoicesIndex.add(index);
    } else {
      newSelectedChoicesIndex.remove(index);
    }

    ref.read(selectedChoicesIndexProvider.notifier).state =
        newSelectedChoicesIndex;
    // TODO: Trigger VM on Integration of submit task and reset index to default
  }
}
