import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survey_flutter_ic/di/provider/di.dart';
import 'package:survey_flutter_ic/model/submit_survey_answer_model.dart';
import 'package:survey_flutter_ic/model/submit_survey_question_model.dart';
import 'package:survey_flutter_ic/model/survey_detail_model.dart';
import 'package:survey_flutter_ic/model/survey_question_model.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_view_state.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';
import 'package:survey_flutter_ic/usecase/get_survey_detail_use_case.dart';
import 'package:survey_flutter_ic/usecase/submit_survey_use_case.dart';

final surveyQuestionsViewModelProvider = StateNotifierProvider.autoDispose<
        SurveyQuestionsViewModel, SurveyQuestionsViewState>(
    (_) => SurveyQuestionsViewModel(
          getIt.get<GetSurveyDetailUseCase>(),
          getIt.get<SubmitSurveyUseCase>(),
        ));

final isLoadingProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(surveyQuestionsViewModelProvider.notifier).isLoading);

final currentIndexProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(surveyQuestionsViewModelProvider.notifier).currentIndex);

final surveyQuestionsProvider = StreamProvider.autoDispose((ref) =>
    ref.watch(surveyQuestionsViewModelProvider.notifier).surveyQuestions);

final surveyNextQuestionsProvider = StreamProvider.autoDispose((ref) =>
    ref.watch(surveyQuestionsViewModelProvider.notifier).surveyNextQuestions);

class SurveyQuestionsViewModel extends StateNotifier<SurveyQuestionsViewState> {
  final GetSurveyDetailUseCase _getSurveyDetailUseCase;
  final SubmitSurveyUseCase _submitSurveyUseCase;

  SurveyQuestionsViewModel(
    this._getSurveyDetailUseCase,
    this._submitSurveyUseCase,
  ) : super(const SurveyQuestionsViewState.init());

  final List<SubmitSurveyQuestionModel> _submitSurveyQuestions = [];

  final BehaviorSubject<bool> _isLoading = BehaviorSubject();

  Stream<bool> get isLoading => _isLoading.stream;

  final BehaviorSubject<int> _currentIndex = BehaviorSubject();

  Stream<int> get currentIndex => _currentIndex.stream;

  final BehaviorSubject<List<SurveyQuestionModel>> _surveyQuestions =
      BehaviorSubject();

  Stream<List<SurveyQuestionModel>> get surveyQuestions =>
      _surveyQuestions.stream;

  final BehaviorSubject<void> _surveyNextQuestions = BehaviorSubject();

  Stream<void> get surveyNextQuestions => _surveyNextQuestions.stream;

  void getSurveyDetail(String surveyId) async {
    _getSurveyDetailUseCase.call(surveyId).asStream().doOnListen(() {
      _isLoading.add(true);
    }).doOnDone(() {
      _isLoading.add(false);
    }).listen((result) {
      if (result is Success<SurveyDetailModel>) {
        _surveyQuestions.add(result.value.questions);
      } else {
        final error = result as Failed<SurveyDetailModel>;
        state = SurveyQuestionsViewState.error(error.getErrorMessage());
      }
    });
  }

  void nextQuestion() async {
    final index = _currentIndex.hasValue ? _currentIndex.value : 0;
    _currentIndex.add(index + 1);

    if (_surveyQuestions.hasValue && index != 0) {
      _surveyNextQuestions.add(null);
    }
  }

  void saveAnswer(List<SubmitSurveyAnswerModel> answers) async {
    final questionId = _surveyQuestions.value[_currentIndex.value - 1].id;
    _submitSurveyQuestions.add(
      SubmitSurveyQuestionModel(
        id: questionId,
        answers: answers,
      ),
    );
  }

  void submitSurvey(String surveyId) async {
    _submitSurveyUseCase
        .call(
          SubmitSurveyUseCaseInput(
            surveyId: surveyId,
            questions: _submitSurveyQuestions,
          ),
        )
        .asStream()
        .doOnListen(() {
      _isLoading.add(true);
    }).doOnDone(() {
      _isLoading.add(false);
    }).listen((result) {
      if (result is Success<void>) {
        _submitSurveyQuestions.clear();
        state = const SurveyQuestionsViewState.navigateToCompletionScreen();
      } else {
        final error = result as Failed<void>;
        state = SurveyQuestionsViewState.error(error.getErrorMessage());
      }
    });
  }

  @override
  void dispose() async {
    _isLoading.close();
    _currentIndex.close();
    _surveyQuestions.close();
    _surveyNextQuestions.close();
    super.dispose();
  }
}
