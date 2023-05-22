import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/ui/survey_detail/survey_detail_view_state.dart';

final surveyDetailViewModelProvider = StateNotifierProvider.autoDispose<
    SurveyDetailViewModel,
    SurveyDetailViewState>((_) => SurveyDetailViewModel());

final surveyProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(surveyDetailViewModelProvider.notifier).survey);

class SurveyDetailViewModel extends StateNotifier<SurveyDetailViewState> {
  SurveyDetailViewModel() : super(const SurveyDetailViewState.init());

  final BehaviorSubject<SurveyModel> _survey = BehaviorSubject();

  Stream<SurveyModel> get survey => _survey.stream;

  void setSurvey(SurveyModel survey) {
    _survey.add(survey);
  }

  @override
  void dispose() async {
    await _survey.close();
    super.dispose();
  }
}
