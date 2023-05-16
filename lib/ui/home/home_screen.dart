import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:survey_flutter_ic/extension/toast_extension.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/home/home_header.dart';
import 'package:survey_flutter_ic/ui/home/home_survey_item.dart';
import 'package:survey_flutter_ic/ui/home/home_view_model.dart';
import 'package:survey_flutter_ic/ui/home/home_view_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ref.read(homeViewModelProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider).value ?? false;
    final today = ref.watch(todayProvider).value ?? '';
    final profileAvatar = ref.watch(profileAvatarProvider).value ?? '';
    final surveys = ref.watch(surveysProvider).value ?? [];

    ref.listen<HomeViewState>(homeViewModelProvider, (_, state) {
      state.maybeWhen(
        error: (message) => showToastMessage(message),
        orElse: () {},
      );
    });

    if (isLoading) {
      return _buildLoadingIndicator();
    } else {
      return _buildHomeScreenContent(
        today,
        profileAvatar,
        surveys,
      );
    }
  }

  Widget _buildHomeScreenContent(
    String today,
    String profileAvatar,
    List<SurveyModel> surveys,
  ) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: surveys.length,
            itemBuilder: (_, index) {
              return HomeSurveyItem(
                survey: surveys[index],
                onNextButtonPressed: () {
                  // TODO: Navigate to detail screen
                  showToastMessage(_currentIndex.toString());
                },
              );
            },
          ),
          SafeArea(
            child: HomeHeader(
              date: today,
              avatar: profileAvatar,
            ),
          ),
          if (surveys.isNotEmpty)
            Positioned(
              bottom: 206,
              child: PageViewDotIndicator(
                currentItem: _currentIndex,
                count: surveys.length,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: space15),
                margin: const EdgeInsets.symmetric(horizontal: space5),
                size: const Size(
                  pagerIndicatorSize,
                  pagerIndicatorSize,
                ),
                unselectedSize: const Size(
                  pagerIndicatorSize,
                  pagerIndicatorSize,
                ),
                unselectedColor: Colors.white.withOpacity(0.2),
                selectedColor: Colors.white,
              ),
            )
        ],
      ),
    );
  }

  // TODO: Create a home shimmer loading
  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
          child: const CircularProgressIndicator(
            color: Colors.white,
          )),
    );
  }
}
