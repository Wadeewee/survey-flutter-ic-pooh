import 'package:flutter_test/flutter_test.dart';
import 'package:survey_flutter_ic/api/request/submit_survey_request.dart';
import 'package:survey_flutter_ic/api/response/survey_detail_response.dart';
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

  @override
  Future<SurveyDetailResponse> getSurveyDetail(
    String id,
  ) async {
    final response = FakeData.apiAndResponse[keySurveyDetail]!;
    if (response.statusCode != 200) {
      throw generateDioError(response.statusCode);
    }
    return SurveyDetailResponse.fromJson(response.json);
  }

  @override
  Future<void> submitSurvey(
    SubmitSurveyRequest body,
  ) async {
    final response = FakeData.apiAndResponse[keySurveySubmit]!;
    if (response.statusCode != 200) {
      throw generateDioError(response.statusCode);
    }
  }
}
