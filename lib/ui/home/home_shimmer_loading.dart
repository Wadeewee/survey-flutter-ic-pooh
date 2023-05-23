import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';

class HomeShimmerLoading extends StatelessWidget {
  const HomeShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(space20),
          child: Shimmer.fromColors(
            baseColor: Colors.white12,
            highlightColor: Colors.white30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderShimmer(screenWidth),
                const Expanded(child: SizedBox.shrink()),
                _buildPagerIndicatorShimmer(screenWidth),
                _buildContentShimmer(screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer(double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlaceholder(screenWidth * 0.3),
              const SizedBox(height: space4),
              _buildPlaceholder(screenWidth * 0.25),
            ],
          ),
        ),
        _buildPlaceholder(
          circleAvatarProfileSize,
          height: circleAvatarProfileSize,
          borderRadius: circleAvatarProfileSize / 2,
        ),
      ],
    );
  }

  Widget _buildPagerIndicatorShimmer(double screenWidth) {
    return _buildPlaceholder(screenWidth * 0.1);
  }

  Widget _buildContentShimmer(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: space20),
        _buildPlaceholder(screenWidth * 0.7),
        const SizedBox(height: space4),
        _buildPlaceholder(screenWidth * 0.4),
        const SizedBox(height: space16),
        _buildPlaceholder(screenWidth * 0.8),
        const SizedBox(height: space4),
        _buildPlaceholder(screenWidth * 0.6),
      ],
    );
  }

  Widget _buildPlaceholder(
    double width, {
    double height = 24.0,
    double borderRadius = borderRadius12,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white,
      ),
    );
  }
}
