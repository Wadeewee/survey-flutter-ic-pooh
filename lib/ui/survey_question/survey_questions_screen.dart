import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_flutter_ic/extension/toast_extension.dart';
import 'package:survey_flutter_ic/gen/assets.gen.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_model.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_state.dart';
import 'package:survey_flutter_ic/widget/circle_next_button.dart';

class SurveyQuestionsScreen extends ConsumerStatefulWidget {
  final String surveyId;

  const SurveyQuestionsScreen({
    super.key,
    required this.surveyId,
  });

  @override
  ConsumerState<SurveyQuestionsScreen> createState() => _SurveyQuestionsState();
}

class _SurveyQuestionsState extends ConsumerState<SurveyQuestionsScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ref.read(surveyQuestionsViewModelProvider.notifier).getSurveyDetail(
          widget.surveyId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider).value ?? false;
    final surveyQuestion = ref.watch(surveyQuestionProvider).value;

    ref.listen<SurveyQuestionsViewState>(surveyQuestionsViewModelProvider,
        (_, state) {
      state.maybeWhen(
        error: (message) => showToastMessage(message),
        orElse: () {},
      );
    });

    if (isLoading) {
      return _buildLoadingIndicator();
    } else {
      return _buildSurveyQuestionsScreenContent(surveyQuestion);
    }
  }

  Widget _buildSurveyQuestionsScreenContent(
    SurveyQuestionModel? surveyQuestion,
  ) {
    final totalQuestions = surveyQuestion?.totalQuestions ?? 0;
    return Scaffold(
      body: Stack(
        children: [
          if (surveyQuestion != null)
            _buildCoverImageUrl(surveyQuestion.largeCoverImageUrl),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(space20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCloseButton(),
                  const SizedBox(height: space30),
                  if (totalQuestions > 0)
                    _buildQuestionsIndicator(totalQuestions),
                  const SizedBox(height: space10),
                  _buildQuestionLabel(surveyQuestion?.text ?? ''),
                  const Expanded(child: SizedBox.shrink()),
                  // TODO: Update the logic to show the next button
                  if (totalQuestions > 0) _buildNextButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Assets.images.icClose.svg(),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildCoverImageUrl(String largeCoverImageUrl) {
    return Image.network(
      largeCoverImageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildQuestionsIndicator(int totalQuestions) {
    return Text(
      "${_currentIndex + 1}/$totalQuestions",
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: fontSize17,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildQuestionLabel(String question) {
    return Text(
      question,
      style: const TextStyle(
        color: Colors.white,
        fontSize: fontSize34,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: CircleNextButton(
        onPressed: () {
          ref
              .read(surveyQuestionsViewModelProvider.notifier)
              .getNextSurveyQuestion(_currentIndex + 1);
          _currentIndex++;
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
          child: const CircularProgressIndicator(
            color: Colors.white,
          )),
    );
  }
}
