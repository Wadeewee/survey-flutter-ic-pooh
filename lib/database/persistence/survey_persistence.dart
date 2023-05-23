import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:survey_flutter_ic/database/dto/survey_dto.dart';

abstract class SurveyPersistence {
  Future<List<SurveyDto>> surveys();

  Future<void> add(List<SurveyDto> surveys);

  Future<void> clear();
}

@Singleton(as: SurveyPersistence)
class SurveyPersistenceImpl extends SurveyPersistence {
  final Box _surveyBox;
  final String _surveyKey = 'surveyKey';

  SurveyPersistenceImpl(this._surveyBox);

  @override
  Future<List<SurveyDto>> surveys() {
    return Future.value(
      List<SurveyDto>.from(
        _surveyBox.get(
          _surveyKey,
          defaultValue: [],
        ),
      ),
    );
  }

  @override
  Future<void> add(List<SurveyDto> surveys) async {
    await _surveyBox.put(_surveyKey, surveys);
  }

  @override
  Future<void> clear() async {
    await _surveyBox.delete(_surveyKey);
  }
}
