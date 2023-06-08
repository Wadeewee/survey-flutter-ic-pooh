import 'package:injectable/injectable.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/api/repository/survey_repository.dart';
import 'package:survey_flutter_ic/model/submit_survey_question_model.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';

class SubmitSurveyUseCaseInput {
  final String surveyId;
  final List<SubmitSurveyQuestionModel> questions;

  SubmitSurveyUseCaseInput({
    required this.surveyId,
    required this.questions,
  });
}

@Injectable()
class SubmitSurveyUseCase extends UseCase<void, SubmitSurveyUseCaseInput> {
  final SurveyRepository _repository;

  const SubmitSurveyUseCase(this._repository);

  @override
  Future<Result<void>> call(SubmitSurveyUseCaseInput params) {
    return _repository
        .submitSurvey(
          surveyId: params.surveyId,
          questions: params.questions,
        )
        // ignore: unnecessary_cast
        .then((value) => Success(value) as Result<void>)
        .onError<NetworkExceptions>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }
}
