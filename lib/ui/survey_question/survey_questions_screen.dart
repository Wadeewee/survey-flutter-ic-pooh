import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_flutter_ic/extension/context_extension.dart';
import 'package:survey_flutter_ic/gen/assets.gen.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/navigation/route.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_question_id.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_question_item.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_model.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_state.dart';
import 'package:survey_flutter_ic/widget/circle_next_button.dart';
import 'package:survey_flutter_ic/widget/flat_button_text.dart';
import 'package:survey_flutter_ic/widget/survey_alert_dialog.dart';

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
        navigateToCompletionScreen: () {
          context.goNamed(RoutePath.completion.name);
        },
        error: (message) {
          showDialog(
            context: context,
            builder: (_) => SurveyAlertDialog(
              title: context.localization.alert_dialog_title_error,
              description: message,
              positiveActionText:
                  context.localization.alert_dialog_button_action_ok,
            ),
          );
        },
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
            surveyQuestions[currentIndex].coverImageOpacity,
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
                  (currentIndex + 1) == surveyQuestions.length
                      ? _buildSubmitButton()
                      : _buildNextButton(currentIndex),
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
        key: SurveyQuestionWidgetId.closeButton,
        icon: Assets.images.icClose.svg(),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {
          context.hideKeyboard();
          showDialog(
            context: context,
            builder: (_) => SurveyAlertDialog(
              title: context.localization.alert_dialog_title_warning,
              description: context
                  .localization.survey_question_quit_confirmation_description,
              positiveActionText:
                  context.localization.alert_dialog_button_action_yes,
              negativeActionText:
                  context.localization.alert_dialog_button_action_cancel,
              onPositiveActionPressed: () => context.pop(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoverImageUrl(
    String largeCoverImageUrl,
    double coverImageOpacity,
  ) {
    return Container(
      key: SurveyQuestionWidgetId.coverImageUrl,
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.network(largeCoverImageUrl).image,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(coverImageOpacity),
            BlendMode.darken,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: const SizedBox(),
      ),
    );
  }

  Widget _buildQuestionsIndicator(
    int currentIndex,
    int totalQuestions,
  ) {
    return Text(
      key: SurveyQuestionWidgetId.questionsIndicator,
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
      ),
    );
  }

  Widget _buildNextButton(int currentIndex) {
    return Align(
      alignment: Alignment.bottomRight,
      child: CircleNextButton(
        key: SurveyQuestionWidgetId.nextQuestionButton,
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

  Widget _buildSubmitButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FlatButtonText(
        key: SurveyQuestionWidgetId.submitButton,
        text: context.localization.survey_question_submit_button,
        isEnabled: true,
        onPressed: () {
          ref
              .read(surveyQuestionsViewModelProvider.notifier)
              .submitSurvey(widget.surveyId);
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
