import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survey_flutter_ic/di/provider/di.dart';
import 'package:survey_flutter_ic/ui/splash/splash_view_state.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';
import 'package:survey_flutter_ic/usecase/is_authorized_use_case.dart';

final splashViewModelProvider =
    StateNotifierProvider.autoDispose<SplashViewModel, SplashViewState>(
        (_) => SplashViewModel(
              getIt.get<IsAuthorizedUseCase>(),
            ));

final isAuthorizedProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(splashViewModelProvider.notifier).isAuthorized);

class SplashViewModel extends StateNotifier<SplashViewState> {
  final IsAuthorizedUseCase _isAuthorizedUseCase;

  SplashViewModel(this._isAuthorizedUseCase)
      : super(const SplashViewState.init());

  final BehaviorSubject<bool> _isAuthorized = BehaviorSubject();

  Stream<bool> get isAuthorized => _isAuthorized.stream;

  Future checkIsAuthorized() async {
    _isAuthorizedUseCase.call().asStream().listen((result) {
      final isAuthorized = (result as Success<bool>).value;
      _isAuthorized.add(isAuthorized);
    });
  }

  @override
  void dispose() async {
    await _isAuthorized.close();
    super.dispose();
  }
}
