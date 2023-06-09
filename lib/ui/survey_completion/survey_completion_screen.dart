import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';

class SurveyCompletionScreen extends ConsumerStatefulWidget {
  const SurveyCompletionScreen({super.key});

  @override
  ConsumerState<SurveyCompletionScreen> createState() =>
      _SurveyCompletionState();
}

class _SurveyCompletionState extends ConsumerState<SurveyCompletionScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: Update widget
    return const Scaffold(
      body: Center(
        child: Text(
          'Completion Screen',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize34,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
