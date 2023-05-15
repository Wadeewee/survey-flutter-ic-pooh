import 'package:flutter/material.dart';
import 'package:survey_flutter_ic/gen/assets.gen.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';

class CircleNextButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CircleNextButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(space15),
      shape: const CircleBorder(),
      child: Assets.images.icArrowRight.svg(),
    );
  }
}
