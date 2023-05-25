import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';
import 'package:survey_flutter_ic/usecase/get_cached_surveys_use_case.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group('GetCachedSurveysUseCaseTest', () {
    late MockSurveyRepository mockSurveyRepository;
    late GetCachedSurveysUseCase useCase;

    setUp(() async {
      mockSurveyRepository = MockSurveyRepository();
      useCase = GetCachedSurveysUseCase(mockSurveyRepository);
    });

    test(
        'When calling GetCachedSurveys successfully, it returns the result Success',
        () async {
      final expected = <SurveyModel>[];
      when(mockSurveyRepository.getCachedSurveys())
          .thenAnswer((_) async => expected);

      final result = await useCase.call();

      expect(result, isA<Success>());
      expect((result as Success).value, expected);
    });

    test('When calling GetCachedSurveys failed, it returns the result Failed',
        () async {
      const expected = NetworkExceptions.unexpectedError();

      when(mockSurveyRepository.getCachedSurveys())
          .thenAnswer((_) async => Future.error(expected));

      final result = await useCase.call();

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, expected);
    });
  });
}
