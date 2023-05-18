import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survey_flutter_ic/di/provider/di.dart';
import 'package:survey_flutter_ic/extension/date_extension.dart';
import 'package:survey_flutter_ic/model/profile_model.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/ui/home/home_view_state.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';
import 'package:survey_flutter_ic/usecase/get_profile_use_case.dart';
import 'package:survey_flutter_ic/usecase/get_survey_use_case.dart';

const _defaultFirstPageIndex = 1;
const _defaultPageSize = 10;

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeViewState>(
        (_) => HomeViewModel(
              getIt.get<GetProfileUseCase>(),
              getIt.get<GetSurveysUseCase>(),
            ));

final isLoadingProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(homeViewModelProvider.notifier).isLoading);

final todayProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(homeViewModelProvider.notifier).today);

final profileAvatarProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(homeViewModelProvider.notifier).profileAvatar);

final surveysProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(homeViewModelProvider.notifier).surveys);

class HomeViewModel extends StateNotifier<HomeViewState> {
  final GetProfileUseCase _getProfileUseCase;
  final GetSurveysUseCase _getSurveysUseCase;

  HomeViewModel(
    this._getProfileUseCase,
    this._getSurveysUseCase,
  ) : super(const HomeViewState.init());

  final BehaviorSubject<bool> _isLoading = BehaviorSubject();

  Stream<bool> get isLoading => _isLoading.stream;

  final BehaviorSubject<String> _today = BehaviorSubject();

  Stream<String> get today => _today.stream;

  final BehaviorSubject<String> _profileAvatar = BehaviorSubject();

  Stream<String> get profileAvatar => _profileAvatar.stream;

  final BehaviorSubject<List<SurveyModel>> _surveys = BehaviorSubject();

  Stream<List<SurveyModel>> get surveys => _surveys.stream;

  void loadData() async {
    final profileStream = _getProfileUseCase.call().asStream();
    final surveysStream = _getSurveysUseCase
        .call(
          GetSurveysInput(
            pageNumber: _defaultFirstPageIndex,
            pageSize: _defaultPageSize,
          ),
        )
        .asStream();

    ZipStream.zip2(
      profileStream,
      surveysStream,
      (profileResult, surveysResult) {
        _today.add(DateTime.now().getFormattedString());

        if (profileResult is Success<ProfileModel>) {
          _profileAvatar.add(profileResult.value.avatarUrl);
        }

        if (surveysResult is Success<List<SurveyModel>>) {
          _surveys.add(surveysResult.value);
        } else {
          final error = surveysResult as Failed<List<SurveyModel>>;
          state = HomeViewState.error(error.getErrorMessage());
        }
      },
    ).doOnListen(() {
      _isLoading.add(true);
    }).doOnDone(() {
      _isLoading.add(false);
    }).listen((_) {});
  }

  @override
  void dispose() async {
    await _isLoading.close();
    await _today.close();
    await _profileAvatar.close();
    await _surveys.close();
    super.dispose();
  }
}
