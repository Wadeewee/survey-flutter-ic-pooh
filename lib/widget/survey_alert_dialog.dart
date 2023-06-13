import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';

class SurveyAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final String positiveActionText;
  final String? negativeActionText;
  final VoidCallback? onPositiveActionPressed;

  const SurveyAlertDialog({
    super.key,
    required this.title,
    required this.description,
    required this.positiveActionText,
    this.negativeActionText,
    this.onPositiveActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: fontSize17,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        description,
        style: const TextStyle(
          color: Colors.black,
          fontSize: fontSize17,
          fontWeight: FontWeight.normal,
        ),
      ),
      actions: <Widget>[
        if (negativeActionText != null)
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(
              negativeActionText ?? '',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: fontSize17,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        TextButton(
          onPressed: () {
            context.pop(false);
            onPositiveActionPressed?.call();
          },
          child: Text(
            positiveActionText,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: fontSize17,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
