import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/api/repository/survey_repository.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';

@Injectable()
class GetCachedSurveysUseCase extends NoParamsUseCase<List<SurveyModel>> {
  final SurveyRepository _surveyRepository;

  const GetCachedSurveysUseCase(this._surveyRepository);

  @override
  Future<Result<List<SurveyModel>>> call() {
    return _surveyRepository
        .getCachedSurveys()
        // ignore: unnecessary_cast
        .then((value) => Success(value) as Result<List<SurveyModel>>)
        .onError<NetworkExceptions>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }
}
