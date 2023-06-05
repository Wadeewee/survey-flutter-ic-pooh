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
    final selectedIndex = ref.watch(selectedChoicesIndexProvider);

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
                    color: selectedIndex.contains(index)
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    fontSize: fontSize20,
                    fontWeight: selectedIndex.contains(index)
                        ? FontWeight.w800
                        : FontWeight.w400,
                  ),
                ),
              ),
              Checkbox(
                shape: const CircleBorder(),
                side: BorderSide(
                  color: selectedIndex.contains(index)
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                activeColor: Colors.white,
                checkColor: Colors.black,
                value: selectedIndex.contains(index),
                onChanged: (bool? value) =>
                    _handleAnswerSelection(ref, index, value),
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
    int index,
    bool? value,
  ) {
    final selectedIndex = ref.watch(selectedChoicesIndexProvider);
    final newSelectedChoicesIndex = List<int>.from(selectedIndex);

    if (selectionType == SelectionType.one) {
      newSelectedChoicesIndex.clear();
    }

    if (value == true) {
      newSelectedChoicesIndex.add(index);
    } else {
      newSelectedChoicesIndex.remove(index);
    }

    ref.read(selectedChoicesIndexProvider.notifier).state =
        newSelectedChoicesIndex;
    // TODO: Trigger VM on Integration of submit task
  }
}
