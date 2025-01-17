import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey_flutter_ic/model/submit_survey_answer_model.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_model.dart';

const _defaultSelectedEmojiIndex = 2;
const _maxAnswerChoices = 5;
const List<String> _faceModes = ['😡', '😕', '😐', '🙂', '😄'];

final selectedEmojiIndexProvider =
    StateProvider.autoDispose<int>((_) => _defaultSelectedEmojiIndex);

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

    ref.listen(surveyNextQuestionsProvider, (_, __) {
      ref.read(surveyQuestionsViewModelProvider.notifier).saveAnswer([
        SubmitSurveyAnswerModel(
          id: answers[selectedAnswerIndex].id,
          answer: answers[selectedAnswerIndex].text,
        ),
      ]);
      ref.read(selectedEmojiIndexProvider.notifier).state =
          _defaultSelectedEmojiIndex;
    });

    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _maxAnswerChoices,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            ref.read(selectedEmojiIndexProvider.notifier).state = index;
          },
          child: Center(
            child: Text(
              _getEmoji(displayType, index),
              style: TextStyle(
                color: _getColor(displayType, index, selectedAnswerIndex),
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

  String _getEmoji(
    DisplayType displayType,
    int index,
  ) {
    switch (displayType) {
      case DisplayType.smiley:
        return _faceModes[index];
      case DisplayType.star:
        return '⭐️';
      case DisplayType.heart:
        return '❤️';
      default:
        return '👍🏻';
    }
  }

  Color _getColor(
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
