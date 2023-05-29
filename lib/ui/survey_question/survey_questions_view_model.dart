import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survey_flutter_ic/di/provider/di.dart';
import 'package:survey_flutter_ic/model/survey_detail_model.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_state.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';
import 'package:survey_flutter_ic/usecase/get_survey_detail_use_case.dart';

final surveyQuestionsViewModelProvider = StateNotifierProvider.autoDispose<
        SurveyQuestionsViewModel, SurveyQuestionsViewState>(
    (_) => SurveyQuestionsViewModel(getIt.get<GetSurveyDetailUseCase>()));

final isLoadingProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(surveyQuestionsViewModelProvider.notifier).isLoading);

final surveyQuestionProvider = StreamProvider.autoDispose((ref) =>
    ref.watch(surveyQuestionsViewModelProvider.notifier).surveyQuestion);

class SurveyQuestionsViewModel extends StateNotifier<SurveyQuestionsViewState> {
  final GetSurveyDetailUseCase _getSurveyDetailUseCase;

  List<SurveyQuestionModel> surveyQuestions = [];

  SurveyQuestionsViewModel(this._getSurveyDetailUseCase)
      : super(const SurveyQuestionsViewState.init());

  final BehaviorSubject<bool> _isLoading = BehaviorSubject();

  Stream<bool> get isLoading => _isLoading.stream;

  final BehaviorSubject<SurveyQuestionModel> _surveyQuestion =
      BehaviorSubject();

  Stream<SurveyQuestionModel> get surveyQuestion => _surveyQuestion.stream;

  void getSurveyDetail(String surveyId) async {
    _getSurveyDetailUseCase.call(surveyId).asStream().doOnListen(() {
      _isLoading.add(true);
    }).doOnDone(() {
      _isLoading.add(false);
    }).listen((result) {
      if (result is Success<SurveyDetailModel>) {
        surveyQuestions = result.value.questions;
        _surveyQuestion.add(surveyQuestions.first);
      } else {
        final error = result as Failed<SurveyDetailModel>;
        state = SurveyQuestionsViewState.error(error.getErrorMessage());
      }
    });
  }

  void getNextSurveyQuestion(int index) async {
    _surveyQuestion.add(surveyQuestions[index]);
  }

  @override
  void dispose() async {
    _surveyQuestion.close();
    super.dispose();
  }
}
