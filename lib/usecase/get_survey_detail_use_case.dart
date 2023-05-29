import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/api/repository/survey_repository.dart';
import 'package:survey_flutter_ic/model/survey_detail_model.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';

@Injectable()
class GetSurveyDetailUseCase extends UseCase<SurveyDetailModel, String> {
  final SurveyRepository _surveyRepository;

  const GetSurveyDetailUseCase(this._surveyRepository);

  @override
  Future<Result<SurveyDetailModel>> call(String params) {
    return _surveyRepository
        .getSurveyDetail(surveyId: params)
        // ignore: unnecessary_cast
        .then((value) => Success(value) as Result<SurveyDetailModel>)
        .onError<NetworkExceptions>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }
}
