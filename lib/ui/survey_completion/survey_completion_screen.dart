import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:survey_flutter_ic/extension/context_extension.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';

const _lottieCompletion =
    'https://assets2.lottiefiles.com/packages/lf20_pmYw5P.json';
const _animationDurationInMilliseconds = 2000;

class SurveyCompletionScreen extends ConsumerStatefulWidget {
  const SurveyCompletionScreen({super.key});

  @override
  ConsumerState<SurveyCompletionScreen> createState() =>
      _SurveyCompletionState();
}

class _SurveyCompletionState extends ConsumerState<SurveyCompletionScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: _animationDurationInMilliseconds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.network(
            _lottieCompletion,
            controller: _controller,
            onLoaded: (composition) {
              _controller.forward().whenComplete(() {
                context.pop();
                _controller.reset();
              });
            },
          ),
          const SizedBox(height: space20),
          Text(
            context.localization.survey_completion,
            style: const TextStyle(
              color: Colors.white,
              fontSize: fontSize34,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
