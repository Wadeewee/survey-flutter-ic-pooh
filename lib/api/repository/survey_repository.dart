import 'package:injectable/injectable.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/api/service/survey_service.dart';
import 'package:survey_flutter_ic/database/dto/survey_dto.dart';
import 'package:survey_flutter_ic/database/persistence/survey_persistence.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';

abstract class SurveyRepository {
  Future<List<SurveyModel>> getSurveys({
    required int number,
    required int size,
  });

  Future<List<SurveyModel>> getCachedSurveys();

  Future<void> saveSurveys(List<SurveyModel> surveys);
}

@LazySingleton(as: SurveyRepository)
class SurveyRepositoryImpl extends SurveyRepository {
  final SurveyService _surveyService;
  final SurveyPersistence _surveyPersistence;

  SurveyRepositoryImpl(this._surveyService, this._surveyPersistence);

  @override
  Future<List<SurveyModel>> getSurveys({
    required int number,
    required int size,
  }) async {
    try {
      final response = await _surveyService.getSurveys(number, size);
      final surveysModel = response.surveys
          .map((survey) => SurveyModel.fromResponse(survey))
          .toList();

      return surveysModel;
    } catch (exception) {
      throw NetworkExceptions.fromDioException(exception);
    }
  }

  @override
  Future<List<SurveyModel>> getCachedSurveys() async {
    final surveysDto = await _surveyPersistence.surveys();
    return surveysDto.map((e) => SurveyModel.fromDto(e)).toList();
  }

  @override
  Future<void> saveSurveys(List<SurveyModel> surveys) async {
    final currentSurveys = await _surveyPersistence.surveys();
    final surveysDto = surveys.map((e) => SurveyDto.fromModel(e)).toList();

    if (currentSurveys.isNotEmpty) {
      await clearCached();
      _surveyPersistence.add(surveysDto);
    } else {
      _surveyPersistence.add(surveysDto);
    }
  }

  Future<void> clearCached() async {
    _surveyPersistence.clear();
  }
}
