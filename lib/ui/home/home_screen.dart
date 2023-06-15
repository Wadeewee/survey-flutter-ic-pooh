import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:survey_flutter_ic/extension/context_extension.dart';
import 'package:survey_flutter_ic/extension/toast_extension.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/navigation/route.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/home/home_drawer.dart';
import 'package:survey_flutter_ic/ui/home/home_header.dart';
import 'package:survey_flutter_ic/ui/home/home_shimmer_loading.dart';
import 'package:survey_flutter_ic/ui/home/home_survey_item.dart';
import 'package:survey_flutter_ic/ui/home/home_view_model.dart';
import 'package:survey_flutter_ic/ui/home/home_view_state.dart';
import 'package:survey_flutter_ic/ui/home/home_widget_id.dart';
import 'package:survey_flutter_ic/widget/survey_alert_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
      return const HomeShimmerLoading();
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
      key: _scaffoldKey,
      endDrawer: HomeDrawer(
        // TODO: Bind the real data on integrate task
        name: "PoohSuphawadee",
        avatar: profileAvatar,
        onSignOutPressed: () {
          showDialog(
            context: context,
            builder: (_) => SurveyAlertDialog(
              title: context.localization.alert_dialog_title_confirmation,
              description:
                  context.localization.home_sign_out_confirmation_description,
              positiveActionText:
                  context.localization.home_sign_out_button_action,
              negativeActionText:
                  context.localization.alert_dialog_button_action_cancel,
              onPositiveActionPressed: () {
                _scaffoldKey.currentState?.closeEndDrawer();
                // TODO: Handle on integrate task
              },
            ),
          );
        },
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.white30,
        onRefresh: () {
          _currentIndex = 0;
          return ref
              .read(homeViewModelProvider.notifier)
              .loadData(isRefresh: true);
        },
        child: Stack(
          children: [
            _buildPagerView(surveys),
            FractionallySizedBox(
              heightFactor: 0.2,
              child: ListView(),
            ),
            FractionallySizedBox(
              heightFactor: 0.3,
              child: SafeArea(
                child: HomeHeader(
                  date: today,
                  avatar: profileAvatar,
                  onAvatarPressed: () =>
                      _scaffoldKey.currentState?.openEndDrawer(),
                ),
              ),
            ),
            if (surveys.isNotEmpty) _buildPagerIndicator(surveys),
          ],
        ),
      ),
    );
  }

  Widget _buildPagerView(List<SurveyModel> surveys) {
    return PageView.builder(
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
            context.goNamed(
              RoutePath.surveyDetail.name,
              extra: surveys[_currentIndex],
            );
          },
        );
      },
    );
  }

  Widget _buildPagerIndicator(List<SurveyModel> surveys) {
    return Positioned(
      key: HomeWidgetId.pagerIndicator,
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
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
