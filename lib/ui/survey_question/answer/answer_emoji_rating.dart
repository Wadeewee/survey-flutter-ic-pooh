import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey_flutter_ic/extension/toast_extension.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';

const defaultSelectedEmojiIndex = 2;
const maxAnswerChoices = 5;
const List<String> faceModes = ['😡', '😕', '😐', '🙂', '😄'];

final selectedEmojiIndexProvider =
    StateProvider.autoDispose<int>((_) => defaultSelectedEmojiIndex);

class AnswerEmojiRating extends ConsumerWidget {
  final DisplayType displayType;
  final List<SurveyAnswerModel> answers;

  const AnswerEmojiRating({
    super.key,
    required this.displayType,
    required this.answers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAnswerIndex = ref.watch(selectedEmojiIndexProvider);

    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: maxAnswerChoices,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            ref.read(selectedEmojiIndexProvider.notifier).state = index;
            // TODO: Trigger VM on Integration of submit task and reset index to default
            showToastMessage(answers[index].text);
          },
          child: Center(
            child: Text(
              getEmoji(displayType, index),
              style: TextStyle(
                color: getColor(displayType, index, selectedAnswerIndex),
                fontSize: fontSize34,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) {
        return const SizedBox(width: space20);
      },
    );
  }

  String getEmoji(
    DisplayType displayType,
    int index,
  ) {
    switch (displayType) {
      case DisplayType.smiley:
        return faceModes[index];
      case DisplayType.star:
        return '⭐️';
      case DisplayType.heart:
        return '❤️';
      default:
        return '👍🏻';
    }
  }

  Color getColor(
    DisplayType displayType,
    int index,
    int selectedAnswerIndex,
  ) {
    if (displayType == DisplayType.smiley) {
      return index == selectedAnswerIndex
          ? Colors.black
          : Colors.black.withOpacity(0.5);
    } else {
      return index <= selectedAnswerIndex
          ? Colors.black
          : Colors.black.withOpacity(0.5);
    }
  }
}
