import 'package:flutter/material.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/widget/circle_next_button.dart';

class HomeSurveyItem extends StatelessWidget {
  final SurveyModel survey;
  final VoidCallback onNextButtonPressed;

  const HomeSurveyItem({
    super.key,
    required this.survey,
    required this.onNextButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPageItem(survey);
  }

  Widget _buildPageItem(SurveyModel survey) {
    return Stack(
      children: [
        Image.network(
          survey.largeCoverImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: space20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildTitle(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _buildDescription(),
                  ),
                  _buildNextButton(),
                ],
              ),
              const SizedBox(height: 54),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      survey.title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: fontSize28,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      survey.description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: fontSize17,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildNextButton() {
    return CircleNextButton(
      onPressed: () => onNextButtonPressed.call(),
    );
  }
}
