import 'package:flutter_test/flutter_test.dart';
import 'package:survey_flutter_ic/api/response/surveys_response.dart';
import 'package:survey_flutter_ic/api/service/survey_service.dart';

import '../fake_data.dart';

class FakeSurveyService extends Fake implements SurveyService {
  @override
  Future<SurveysResponse> getSurveys(
    int number,
    int size,
  ) async {
    final response = FakeData.apiAndResponse[keySurveys]!;
    if (response.statusCode != 200) {
      throw generateDioError(response.statusCode);
    }
    return SurveysResponse.fromJson(response.json);
  }
}