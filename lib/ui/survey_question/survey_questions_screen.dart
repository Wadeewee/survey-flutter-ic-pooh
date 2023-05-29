import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_flutter_ic/extension/toast_extension.dart';
import 'package:survey_flutter_ic/gen/assets.gen.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildCoverImageUrl(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(space20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCloseButton(),
                  const SizedBox(height: space30),
                  _buildQuestionsIndicator(),
                  const SizedBox(height: space10),
                  _buildQuestionLabel(),
                  const Expanded(child: SizedBox.shrink()),
                  _buildNextButton(),
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

  Widget _buildCoverImageUrl() {
    return Image.network(
      // TODO: Bind data from VM.
      "https://i.postimg.cc/NjT59j53/Background-3x.jpg",
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildQuestionsIndicator() {
    return Text(
      // TODO: Bind data from VM.
      "1/5",
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: fontSize17,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildQuestionLabel() {
    return const Text(
      // TODO: Bind data from VM.
      "How fulfilled did you fell during this WFH period?",
      style: TextStyle(
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
          // TODO: Show the next question
          showToastMessage("Next question");
        },
      ),
    );
  }
}
