import 'package:flutter_config/flutter_config.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/api/repository/survey_repository.dart';
import 'package:survey_flutter_ic/api/request/submit_survey_request.dart';
import 'package:survey_flutter_ic/api/response/survey_detail_response.dart';
import 'package:survey_flutter_ic/api/response/surveys_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey_flutter_ic/database/dto/survey_dto.dart';
import 'package:survey_flutter_ic/model/survey_detail_model.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import '../../mocks/generate_mocks.mocks.dart';
import '../../utils/file_utils.dart';

void main() {
  FlutterConfig.loadValueForTesting({
    'CLIENT_ID': 'CLIENT_ID',
    'CLIENT_SECRET': 'CLIENT_SECRET',
  });

  group('SurveyRepository', () {
    late MockSurveyService mockSurveyService;
    late MockSurveyPersistence mockSurveyPersistence;
    late SurveyRepository repository;

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

    final surveys = surveysDto.map((e) => SurveyModel.fromDto(e)).toList();

    final submitSurveyRequest = SubmitSurveyRequest(
      surveyId: 'survey_id',
      questions: [],
    );

    setUp(() {
      mockSurveyService = MockSurveyService();
      mockSurveyPersistence = MockSurveyPersistence();

      repository = SurveyRepositoryImpl(
        mockSurveyService,
        mockSurveyPersistence,
      );
    });

    test(
        'When calling GetSurveys successfully, it emits the corresponding SurveyModel',
        () async {
      final json = await FileUtils.loadFile(
          'test_resource/fake_response/fake_surveys_response.json');
      final expected = SurveysResponse.fromJson(json);

      when(mockSurveyService.getSurveys(any, any))
          .thenAnswer((_) async => expected);

      final result = await repository.getSurveys(
        number: 1,
        size: 10,
      );

      expect(result.first, SurveyModel.fromResponse(expected.surveys.first));
      expect(result.last, SurveyModel.fromResponse(expected.surveys.last));
    });

    test('When calling GetSurveys failed, it returns NetworkExceptions error',
        () async {
      when(mockSurveyService.getSurveys(any, any)).thenThrow(MockDioError());

      result() => repository.getSurveys(number: 1, size: 10);

      expect(result, throwsA(isA<NetworkExceptions>()));
    });

    test(
        'When calling GetSurveyDetail successfully, it emits the corresponding SurveyDetailModel',
        () async {
      final json = await FileUtils.loadFile(
          'test_resource/fake_response/fake_survey_detail_response.json');
      final expected = SurveyDetailResponse.fromJson(json);

      when(mockSurveyService.getSurveyDetail(any))
          .thenAnswer((_) async => expected);

      final result = await repository.getSurveyDetail(surveyId: 'id');

      expect(result, SurveyDetailModel.fromResponse(expected));
    });

    test(
        'When calling GetSurveyDetail failed, it returns NetworkExceptions error',
        () async {
      when(mockSurveyService.getSurveyDetail(any)).thenThrow(MockDioError());

      result() => repository.getSurveyDetail(surveyId: 'id');

      expect(result, throwsA(isA<NetworkExceptions>()));
    });

    test(
        'When calling GetCachedSurveys, it emits the corresponding SurveyModel',
        () async {
      when(mockSurveyPersistence.getSurveys())
          .thenAnswer((_) async => surveysDto);

      final result = await repository.getCachedSurveys();

      expect(result.first, SurveyModel.fromDto(surveysDto.first));
    });

    test(
        'When calling SaveSurveys with the currentSurveys is empty, it should save SurveysDto',
        () async {
      when(mockSurveyPersistence.getSurveys()).thenAnswer((_) async => []);

      await repository.saveSurveys(surveys);

      verify(mockSurveyPersistence.add(surveysDto));
      verifyNever(mockSurveyPersistence.clear());
    });

    test(
        'When calling SaveSurveys with the currentSurveys is not empty, it should first clear the cache and then save SurveysDto',
        () async {
      when(mockSurveyPersistence.getSurveys())
          .thenAnswer((_) async => surveysDto);

      await repository.saveSurveys(surveys);

      verifyInOrder([
        mockSurveyPersistence.clear(),
        mockSurveyPersistence.add(surveysDto),
      ]);
    });

    test('When calling SubmitSurvey successfully, it returns empty result',
        () async {
      when(mockSurveyService.submitSurvey(any)).thenAnswer((_) async => []);

      final result = await repository.submitSurvey(
        submitSurveyRequest: submitSurveyRequest,
      );

      expect(() async => result, isA<void>());
    });

    test('When calling SubmitSurvey failed, it returns NetworkExceptions error',
        () async {
      when(mockSurveyService.submitSurvey(any)).thenThrow(MockDioError());

      result() =>
          repository.submitSurvey(submitSurveyRequest: submitSurveyRequest);

      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });
}
