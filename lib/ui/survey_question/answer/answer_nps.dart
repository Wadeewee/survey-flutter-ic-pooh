import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey_flutter_ic/extension/context_extension.dart';
import 'package:survey_flutter_ic/model/submit_survey_answer_model.dart';
import 'package:survey_flutter_ic/model/survey_answer_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_model.dart';

const _defaultSelectedNpsIndex = -1;
const _maxAnswerChoices = 10;
const _lowestThreshold = 3;
const _highestThreshold = 8;

final selectedNpsIndexProvider =
    StateProvider.autoDispose<int>((_) => _defaultSelectedNpsIndex);

class AnswerNps extends ConsumerWidget {
  final List<SurveyAnswerModel> answers;

  const AnswerNps({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAnswerIndex = ref.watch(selectedNpsIndexProvider);

    ref.listen(surveyNextQuestionsProvider, (_, __) {
      ref.read(surveyQuestionsViewModelProvider.notifier).saveAnswer([
        SubmitSurveyAnswerModel(
          id: selectedAnswerIndex == _defaultSelectedNpsIndex
              ? answers.first.id
              : answers[selectedAnswerIndex].id,
          answer: selectedAnswerIndex == _defaultSelectedNpsIndex
              ? answers.first.text
              : (selectedAnswerIndex + 1).toString(),
        ),
      ]);
      ref.read(selectedNpsIndexProvider.notifier).state =
          _defaultSelectedNpsIndex;
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: npsAnswerHeight,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(space10),
          ),
          child: Row(
            children: List.generate(
              _maxAnswerChoices,
              (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(selectedNpsIndexProvider.notifier).state = index;
                    },
                    child: _buildItem(index, selectedAnswerIndex),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: space16),
        _buildDescription(
          selectedAnswerIndex + 1,
          context.localization.survey_question_nps_lowest_description,
          context.localization.survey_question_nps_highest_description,
        ),
      ],
    );
  }

  Widget _buildItem(
    int index,
    int selectedAnswerIndex,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: (index == _maxAnswerChoices - 1)
                ? Colors.transparent
                : Colors.white,
          ),
        ),
      ),
      child: Center(
        child: Text(
          (index + 1).toString(),
          style: TextStyle(
            color: index <= selectedAnswerIndex
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            fontSize: fontSize17,
            fontWeight: index <= selectedAnswerIndex
                ? FontWeight.w800
                : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(
    int index,
    String lowestDescriptionThreshold,
    String highestDescriptionThreshold,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lowestDescriptionThreshold,
          style: TextStyle(
            fontSize: fontSize17,
            color: index <= _lowestThreshold
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          highestDescriptionThreshold,
          style: TextStyle(
            fontSize: fontSize17,
            color: index >= _highestThreshold
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
