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

final currentIndexProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(surveyQuestionsViewModelProvider.notifier).currentIndex);

final surveyQuestionsProvider = StreamProvider.autoDispose((ref) =>
    ref.watch(surveyQuestionsViewModelProvider.notifier).surveyQuestions);

class SurveyQuestionsViewModel extends StateNotifier<SurveyQuestionsViewState> {
  final GetSurveyDetailUseCase _getSurveyDetailUseCase;

  SurveyQuestionsViewModel(this._getSurveyDetailUseCase)
      : super(const SurveyQuestionsViewState.init());

  final BehaviorSubject<bool> _isLoading = BehaviorSubject();

  Stream<bool> get isLoading => _isLoading.stream;

  final BehaviorSubject<int> _currentIndex = BehaviorSubject();

  Stream<int> get currentIndex => _currentIndex.stream;

  final BehaviorSubject<List<SurveyQuestionModel>> _surveyQuestions =
      BehaviorSubject();

  Stream<List<SurveyQuestionModel>> get surveyQuestions =>
      _surveyQuestions.stream;

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
  }

  @override
  void dispose() async {
    _isLoading.close();
    _currentIndex.close();
    _surveyQuestions.close();
    super.dispose();
  }
}
