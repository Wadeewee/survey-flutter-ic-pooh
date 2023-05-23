import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_flutter_ic/extension/context_extension.dart';
import 'package:survey_flutter_ic/extension/toast_extension.dart';
import 'package:survey_flutter_ic/gen/assets.gen.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/widget/flat_button_text.dart';

class SurveyDetailScreen extends ConsumerStatefulWidget {
  final SurveyModel survey;

  const SurveyDetailScreen({
    super.key,
    required this.survey,
  });

  @override
  ConsumerState<SurveyDetailScreen> createState() => _SurveyDetailScreen();
}

class _SurveyDetailScreen extends ConsumerState<SurveyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            // TODO: Binds data from ViewModel
            widget.survey.largeCoverImageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(space20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  const SizedBox(height: space30),
                  _buildTitle(),
                  const SizedBox(height: space16),
                  _buildDescription(),
                  const Expanded(child: SizedBox.shrink()),
                  _buildStartSurveyButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: Assets.images.icArrowLeft.svg(),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () => context.pop(),
    );
  }

  Widget _buildTitle() {
    return Text(
      // TODO: Binds data from ViewModel
      widget.survey.title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: fontSize34,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      // TODO: Binds data from ViewModel
      widget.survey.description,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: fontSize17,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildStartSurveyButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FlatButtonText(
        text: context.localization.survey_detail_start_survey_button,
        isEnabled: true,
        onPressed: () {
          // TODO: Navigate to question screen
          showToastMessage("Start Survey");
        },
      ),
    );
  }
}
