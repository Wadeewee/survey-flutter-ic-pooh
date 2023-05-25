import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/model/survey_detail_model.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';
import 'package:survey_flutter_ic/usecase/get_survey_detail_use_case.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group('GetSurveyDetailUseCaseTest', () {
    late MockSurveyRepository mockSurveyRepository;
    late GetSurveyDetailUseCase useCase;

    setUp(() async {
      mockSurveyRepository = MockSurveyRepository();
      useCase = GetSurveyDetailUseCase(mockSurveyRepository);
    });

    test(
        'When calling GetSurveyDetail successfully, it returns the result Success',
        () async {
      const expected = SurveyDetailModel(
        id: 'id',
        questions: [],
      );
      when(mockSurveyRepository.getSurveyDetail(surveyId: 'id'))
          .thenAnswer((_) async => expected);

      final result = await useCase.call('id');

      expect(result, isA<Success>());
      expect((result as Success).value, expected);
    });

    test('When calling GetSurveyDetail failed, it returns the result Failed',
        () async {
      const expected = NetworkExceptions.unexpectedError();

      when(mockSurveyRepository.getSurveyDetail(surveyId: 'id'))
          .thenAnswer((_) async => Future.error(expected));

      final result = await useCase.call('id');

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, expected);
    });
  });
}
