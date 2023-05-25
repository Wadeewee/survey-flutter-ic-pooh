import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/extension/date_extension.dart';
import 'package:survey_flutter_ic/model/profile_model.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/ui/home/home_view_model.dart';
import 'package:survey_flutter_ic/ui/home/home_view_state.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';

import '../../mocks/generate_mocks.mocks.dart';

void main() {
  group('HomeViewModel', () {
    late MockGetProfileUseCase mockGetProfileUseCase;
    late MockGetAndCacheSurveysUseCase mockGetAndCacheSurveysUseCase;
    late HomeViewModel viewModel;
    late ProviderContainer container;

    const profile = ProfileModel(avatarUrl: "avatarUrl");

    final List<SurveyModel> surveys = <SurveyModel>[
      const SurveyModel(
        id: 'id',
        title: 'title',
        description: 'description',
        isActive: true,
        coverImageUrl: 'coverImageUrl',
        largeCoverImageUrl: 'largeCoverImageUrl',
        createdAt: 'createdAt',
        surveyType: 'surveyType',
      ),
    ];

    setUp(() {
      mockGetProfileUseCase = MockGetProfileUseCase();
      mockGetAndCacheSurveysUseCase = MockGetAndCacheSurveysUseCase();

      container = ProviderContainer(overrides: [
        homeViewModelProvider.overrideWith((ref) => HomeViewModel(
              mockGetProfileUseCase,
              mockGetAndCacheSurveysUseCase,
            ))
      ]);
      viewModel = container.read(homeViewModelProvider.notifier);
      addTearDown(() => container.dispose());

      when(mockGetProfileUseCase.call())
          .thenAnswer((_) async => Success(profile));
      when(mockGetAndCacheSurveysUseCase.call(any))
          .thenAnswer((_) async => Success(surveys));
    });

    test('When initializing HomeViewModel, its state is Init', () {
      expect(container.read(homeViewModelProvider), const HomeViewState.init());
    });

    test('When calling loadData, it emits today', () {
      expect(
        viewModel.today,
        emitsThrough(DateTime.now().getFormattedString()),
      );

      container.read(homeViewModelProvider.notifier).loadData();
    });

    test('When calling loadData, it emits isLoading properly', () {
      expect(
        viewModel.isLoading,
        emitsInOrder([true, false]),
      );

      container.read(homeViewModelProvider.notifier).loadData();
    });

    test('When calling getProfile successfully, it emits avatarUrl', () {
      expect(viewModel.profileAvatar, emitsThrough('avatarUrl'));

      container.read(homeViewModelProvider.notifier).loadData();
    });

    test('When calling getProfile failed, it emits nothing', () {
      when(mockGetProfileUseCase.call()).thenAnswer((_) async => Failed(
          UseCaseException(const NetworkExceptions.defaultError("Error"))));

      expect(viewModel.profileAvatar, neverEmits(profile));

      container.read(homeViewModelProvider.notifier).loadData();
    });

    test('When calling getSurveys successfully, it emits surveys', () {
      expect(viewModel.surveys, emitsThrough(surveys));

      container.read(homeViewModelProvider.notifier).loadData();
    });

    test('When calling getSurveys failed, it returns the error state', () {
      when(mockGetAndCacheSurveysUseCase.call(any)).thenAnswer((_) async =>
          Failed(
              UseCaseException(const NetworkExceptions.defaultError("Error"))));

      expect(
          viewModel.stream,
          emitsThrough(
            const HomeViewState.error("Error"),
          ));

      container.read(homeViewModelProvider.notifier).loadData();
    });
  });
}
