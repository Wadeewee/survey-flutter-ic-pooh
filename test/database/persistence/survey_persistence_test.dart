import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey_flutter_ic/database/dto/survey_dto.dart';
import 'package:survey_flutter_ic/database/persistence/survey_persistence.dart';

import '../../mocks/generate_mocks.mocks.dart';

void main() {
  group('SurveyPersistence', () {
    late MockBox mockBox;
    late SurveyPersistence surveyPersistence;

    final List<SurveyDto> surveysDto = <SurveyDto>[
      const SurveyDto(
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
      mockBox = MockBox();
      surveyPersistence = SurveyPersistenceImpl(mockBox);
    });

    test(
        'When calling Surveys from cache, it emits the corresponding SurveyDto',
        () async {
      when(mockBox.get('surveyKey', defaultValue: [])).thenReturn(surveysDto);

      final result = await surveyPersistence.getSurveys();

      expect(result, surveysDto);
    });

    test('When adding the Surveys to the cache, it should call the put method',
        () async {
      await surveyPersistence.add(surveysDto);

      verify(mockBox.put('surveyKey', surveysDto));
    });

    test(
        'When clearing the Surveys from cache, it should call the delete method',
        () async {
      await surveyPersistence.clear();

      verify(mockBox.delete('surveyKey'));
    });
  });
}
