import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_flutter_ic/extension/context_extension.dart';
import 'package:survey_flutter_ic/gen/assets.gen.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/navigation/route.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/survey_detail/survey_detail_view_model.dart';
import 'package:survey_flutter_ic/ui/survey_detail/survey_detail_widget_id.dart';
import 'package:survey_flutter_ic/widget/flat_button_text.dart';

class SurveyDetailScreen extends ConsumerStatefulWidget {
  final SurveyModel survey;

  const SurveyDetailScreen({
    super.key,
    required this.survey,
  });

  @override
  ConsumerState<SurveyDetailScreen> createState() => _SurveyDetailState();
}

class _SurveyDetailState extends ConsumerState<SurveyDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(surveyDetailViewModelProvider.notifier).setSurvey(widget.survey);
  }

  @override
  Widget build(BuildContext context) {
    final survey = ref.watch(surveyProvider).value;
    final imageCoverUrl = survey?.largeCoverImageUrl ?? '';

    return Scaffold(
      body: Stack(
        children: [
          if (imageCoverUrl.isNotEmpty) _buildCoverImageUrl(imageCoverUrl),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(space20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  const SizedBox(height: space30),
                  _buildTitle(survey?.title ?? ''),
                  const SizedBox(height: space16),
                  _buildDescription(survey?.description ?? ''),
                  const Expanded(child: SizedBox.shrink()),
                  _buildStartSurveyButton(survey?.id ?? ''),
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
      key: SurveyDetailWidgetId.backButton,
      icon: Assets.images.icArrowLeft.svg(),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () => context.pop(),
    );
  }

  Widget _buildCoverImageUrl(String imageCoverUrl) {
    return Image.network(
      key: SurveyDetailWidgetId.coverImageUrl,
      imageCoverUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      key: SurveyDetailWidgetId.titleText,
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: fontSize34,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      key: SurveyDetailWidgetId.descriptionText,
      description,
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: fontSize17,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildStartSurveyButton(String id) {
    return Align(
      key: SurveyDetailWidgetId.startSurveyButton,
      alignment: Alignment.bottomRight,
      child: FlatButtonText(
        text: context.localization.survey_detail_start_survey_button,
        isEnabled: true,
        onPressed: () => context.goNamed(
          RoutePath.surveyQuestions.name,
          params: {surveyIdKey: id},
        ),
      ),
    );
  }
}
