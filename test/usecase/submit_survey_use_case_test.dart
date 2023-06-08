import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';
import 'package:survey_flutter_ic/usecase/submit_survey_use_case.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group('SubmitSurveyUseCase', () {
    late MockSurveyRepository mockRepository;
    late SubmitSurveyUseCase useCase;

    setUp(() {
      mockRepository = MockSurveyRepository();
      useCase = SubmitSurveyUseCase(mockRepository);
    });

    final input = SubmitSurveyUseCaseInput(
      surveyId: 'survey_id',
      questions: [],
    );

    test(
        'When calling SubmitSurvey successfully, it returns the result Success',
        () async {
      when(
        mockRepository.submitSurvey(
          surveyId: input.surveyId,
          questions: input.questions,
        ),
      ).thenAnswer((_) async => (null));

      final result = await useCase.call(input);

      expect(result, isA<Success>());
    });

    test('When calling SubmitSurvey failed, it returns the result Failed',
        () async {
      const exception = NetworkExceptions.unexpectedError();

      when(mockRepository.submitSurvey(
        surveyId: input.surveyId,
        questions: input.questions,
      )).thenAnswer((_) => Future.error(exception));

      final result = await useCase.call(input);

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, exception);
    });
  });
}
