import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_flutter_ic/extension/toast_extension.dart';
import 'package:survey_flutter_ic/gen/assets.gen.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_question_item.dart';
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
  final PageController _pageController = PageController();

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
    final currentIndex = ref.watch(currentIndexProvider).value ?? 0;
    final surveyQuestions = ref.watch(surveyQuestionsProvider).value ?? [];

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
      if (surveyQuestions.isNotEmpty) {
        return _buildSurveyQuestionsScreenContent(
          currentIndex,
          surveyQuestions,
        );
      } else {
        return const SizedBox.shrink();
      }
    }
  }

  Widget _buildSurveyQuestionsScreenContent(
    int currentIndex,
    List<SurveyQuestionModel> surveyQuestions,
  ) {
    return Scaffold(
      body: Stack(
        children: [
          _buildCoverImageUrl(
            surveyQuestions[currentIndex].largeCoverImageUrl,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(space20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCloseButton(),
                  const SizedBox(height: space30),
                  _buildQuestionsIndicator(
                    currentIndex,
                    surveyQuestions.length,
                  ),
                  const SizedBox(height: space10),
                  Expanded(
                    child: _buildAnswerPagerView(
                      surveyQuestions,
                      currentIndex,
                    ),
                  ),
                  _buildNextButton(currentIndex),
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.network(largeCoverImageUrl).image,
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: const SizedBox(),
      ),
    );
  }

  Widget _buildQuestionsIndicator(
    int currentIndex,
    int totalQuestions,
  ) {
    return Text(
      "${currentIndex + 1}/$totalQuestions",
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: fontSize17,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildAnswerPagerView(
    List<SurveyQuestionModel> surveyQuestions,
    int currentIndex,
  ) {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      itemCount: surveyQuestions.length,
      itemBuilder: (_, index) => SurveyQuestionItem(
        surveyQuestion: surveyQuestions[currentIndex],
        onDropdownSelect: (result) {
          // TODO: Trigger VM on Integration task
        },
      ),
    );
  }

  Widget _buildNextButton(int currentIndex) {
    return Align(
      alignment: Alignment.bottomRight,
      child: CircleNextButton(
        onPressed: () {
          ref.read(surveyQuestionsViewModelProvider.notifier).nextQuestion();
          _pageController.animateToPage(
            currentIndex + 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
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
