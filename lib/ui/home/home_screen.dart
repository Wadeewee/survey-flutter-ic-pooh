import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:survey_flutter_ic/extension/date_extension.dart';
import 'package:survey_flutter_ic/extension/toast_extension.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/home/home_header.dart';
import 'package:survey_flutter_ic/ui/home/home_survey_item.dart';
import 'package:survey_flutter_ic/ui/home/home_view_model.dart';
import 'package:survey_flutter_ic/ui/home/home_view_state.dart';

final _loadingStateProvider = StateProvider.autoDispose<bool>((_) => false);
final _profileAvatarProvider = StateProvider.autoDispose<String>((_) => '');

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // TODO: Remove on integration task
  final mockSurveys = const [
    SurveyModel(
        id: "1",
        title: "Working from home\nCheck-In",
        description:
            "We would like to know how you feel about our work from home",
        isActive: false,
        coverImageUrl: "https://i.postimg.cc/NjT59j53/Background-3x.jpg",
        createdAt: "createdAt",
        surveyType: "surveyType"),
    SurveyModel(
        id: "2",
        title: "Career training and development",
        description:
            "We would like to know what are your goals and skills you wanted",
        isActive: false,
        coverImageUrl: "https://i.postimg.cc/yYXfSc3z/Background-3x.jpg",
        createdAt: "createdAt",
        surveyType: "surveyType"),
    SurveyModel(
        id: "3",
        title: "Inclusion and\nbelonging",
        description:
            "Building a workplace culture that prioritizes belonging and inclusion",
        isActive: false,
        coverImageUrl: "https://i.postimg.cc/5tKdfwfb/Background-3x.jpg",
        createdAt: "createdAt",
        surveyType: "surveyType"),
  ];

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      ref.read(homeViewModelProvider.notifier).getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<HomeViewState>(homeViewModelProvider, (_, state) {
      state.maybeWhen(
          getUserProfileSuccess: (profile) => {
                ref.read(_profileAvatarProvider.notifier).state =
                    profile.avatarUrl,
              },
          loading: () {
            ref.read(_loadingStateProvider.notifier).state = true;
          },
          error: (message) => {
                ref.read(_loadingStateProvider.notifier).state = false,
                showToastMessage(message)
              },
          orElse: () => {});
    });

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
            itemCount: mockSurveys.length,
            itemBuilder: (_, index) {
              return HomeSurveyItem(
                survey: mockSurveys[index],
                onNextButtonPressed: () {
                  // TODO: Navigate to detail screen
                  showToastMessage(_currentIndex.toString());
                },
              );
            },
          ),
          SafeArea(
            child: Consumer(
              builder: (context, widgetRef, _) {
                return HomeHeader(
                  date: DateTime.now().getFormattedString(),
                  avatar: widgetRef.watch(_profileAvatarProvider),
                );
              },
            ),
          ),
          Positioned(
            bottom: 206,
            child: PageViewDotIndicator(
              currentItem: _currentIndex,
              count: mockSurveys.length,
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
}
