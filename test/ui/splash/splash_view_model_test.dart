import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey_flutter_ic/ui/splash/splash_view_model.dart';
import 'package:survey_flutter_ic/ui/splash/splash_view_state.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';

import '../../mocks/generate_mocks.mocks.dart';

void main() {
  group('SplashViewModel', () {
    late MockIsAuthorizedUseCase mockIsAuthorizedUseCase;
    late SplashViewModel viewModel;
    late ProviderContainer container;

    setUp(() {
      mockIsAuthorizedUseCase = MockIsAuthorizedUseCase();
      container = ProviderContainer(overrides: [
        splashViewModelProvider
            .overrideWith((ref) => SplashViewModel(mockIsAuthorizedUseCase))
      ]);
      viewModel = container.read(splashViewModelProvider.notifier);
      addTearDown(() => container.dispose());
    });

    test('When initializing SplashViewModel, its state is Init', () {
      expect(container.read(splashViewModelProvider),
          const SplashViewState.init());
    });

    test(
        'When calling CheckIsAuthorized successfully with result is true, it emits isAuthorized with true',
        () {
      when(mockIsAuthorizedUseCase.call())
          .thenAnswer((_) async => Success(true));

      expect(
        viewModel.isAuthorized,
        emitsThrough(true),
      );

      container.read(splashViewModelProvider.notifier).checkIsAuthorized();
    });

    test(
        'When calling CheckIsAuthorized successfully with result is false, it emits isAuthorized with false',
        () {
      when(mockIsAuthorizedUseCase.call())
          .thenAnswer((_) async => Success(false));

      expect(
        viewModel.isAuthorized,
        emitsThrough(false),
      );

      container.read(splashViewModelProvider.notifier).checkIsAuthorized();
    });
  });
}
