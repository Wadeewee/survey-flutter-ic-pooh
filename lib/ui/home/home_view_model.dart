import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survey_flutter_ic/di/provider/di.dart';
import 'package:survey_flutter_ic/extension/date_extension.dart';
import 'package:survey_flutter_ic/model/profile_model.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/ui/home/home_view_state.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';
import 'package:survey_flutter_ic/usecase/get_cached_surveys_use_case.dart';
import 'package:survey_flutter_ic/usecase/get_and_cache_surveys_use_case.dart';
import 'package:survey_flutter_ic/usecase/get_profile_use_case.dart';
import 'package:survey_flutter_ic/usecase/sign_out_use_case.dart';

const _defaultFirstPageIndex = 1;
const _defaultPageSize = 10;

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeViewState>(
        (_) => HomeViewModel(
              getIt.get<GetProfileUseCase>(),
              getIt.get<GetAndCacheSurveysUseCase>(),
              getIt.get<GetCachedSurveysUseCase>(),
              getIt.get<SignOutUseCase>(),
            ));

final isLoadingProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(homeViewModelProvider.notifier).isLoading);

final todayProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(homeViewModelProvider.notifier).today);

final profileProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(homeViewModelProvider.notifier).profile);

final surveysProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(homeViewModelProvider.notifier).surveys);

class HomeViewModel extends StateNotifier<HomeViewState> {
  final GetProfileUseCase _getProfileUseCase;
  final GetAndCacheSurveysUseCase _getAndCacheSurveysUseCase;
  final GetCachedSurveysUseCase _getCachedSurveysUseCase;
  final SignOutUseCase _signOutUseCase;

  HomeViewModel(
    this._getProfileUseCase,
    this._getAndCacheSurveysUseCase,
    this._getCachedSurveysUseCase,
    this._signOutUseCase,
  ) : super(const HomeViewState.init());

  final BehaviorSubject<bool> _isLoading = BehaviorSubject();

  Stream<bool> get isLoading => _isLoading.stream;

  final BehaviorSubject<String> _today = BehaviorSubject();

  Stream<String> get today => _today.stream;

  final BehaviorSubject<ProfileModel> _profile = BehaviorSubject();

  Stream<ProfileModel> get profile => _profile.stream;

  final BehaviorSubject<List<SurveyModel>> _surveys = BehaviorSubject();

  Stream<List<SurveyModel>> get surveys => _surveys.stream;

  Future<void> loadData({bool isRefresh = false}) async {
    if (isRefresh) {
      getAndCacheSurveys();
    } else {
      ZipStream.zip2(
        _getProfileUseCase.call().asStream(),
        _getCachedSurveysUseCase.call().asStream(),
        (profileResult, surveysResult) {
          _today.add(DateTime.now().getFormattedString());

          if (profileResult is Success<ProfileModel>) {
            _profile.add(profileResult.value);
          }

          handleSurveysResult(surveysResult, isCachedStream: true);
        },
      ).doOnListen(() {
        _isLoading.add(true);
      }).doOnDone(() {
        _isLoading.add(false);
      }).listen((_) {});
    }
  }

  Future getAndCacheSurveys() async {
    _getAndCacheSurveysUseCase
        .call(
          GetSurveysInput(
            pageNumber: _defaultFirstPageIndex,
            pageSize: _defaultPageSize,
          ),
        )
        .asStream()
        .doOnListen(() {
      _isLoading.add(true);
    }).doOnDone(() {
      _isLoading.add(false);
    }).listen((result) {
      handleSurveysResult(result);
    });
  }

  void handleSurveysResult(
    Result<List<SurveyModel>> surveysResult, {
    bool isCachedStream = false,
  }) {
    if (surveysResult is Success<List<SurveyModel>>) {
      if (surveysResult.value.isEmpty && isCachedStream) {
        getAndCacheSurveys();
      } else {
        _surveys.add(surveysResult.value);
      }
    } else {
      final error = surveysResult as Failed<List<SurveyModel>>;
      state = HomeViewState.error(error.getErrorMessage());
    }
  }

  void signOut() {
    _signOutUseCase.call().asStream().doOnListen(() {
      _isLoading.add(true);
    }).doOnDone(() {
      _isLoading.add(false);
    }).listen((result) {
      if (result is Success<void>) {
        state = const HomeViewState.navigateToSignInScreen();
      } else {
        final error = result as Failed<void>;
        state = HomeViewState.error(error.getErrorMessage());
      }
    });
  }

  @override
  void dispose() async {
    await _isLoading.close();
    await _today.close();
    await _profile.close();
    await _surveys.close();
    super.dispose();
  }
}
