import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/ui/home/home_screen.dart';
import 'package:survey_flutter_ic/ui/signin/sign_in_screen.dart';
import 'package:survey_flutter_ic/ui/splash/splash_screen.dart';
import 'package:survey_flutter_ic/ui/survey_detail/survey_detail_screen.dart';
import 'package:survey_flutter_ic/ui/survey_question/survey_questions_screen.dart';

const surveyIdKey = 'surveyId';

enum RoutePath {
  root('/', '/'),
  home('/home', 'home'),
  signIn('/sign_in', 'sign_in'),
  surveyDetail('survey_detail', 'survey_detail'),
  surveyQuestions('survey_questions/:$surveyIdKey', 'survey_questions');

  const RoutePath(this.path, this.name);

  final String path;
  final String name;
}

@Singleton()
class AppRouter {
  GoRouter router([
    String? initialLocation,
    dynamic extraBundle,
  ]) =>
      GoRouter(
        initialLocation: initialLocation ?? RoutePath.root.path,
        initialExtra: extraBundle,
        routes: <GoRoute>[
          GoRoute(
            name: RoutePath.root.name,
            path: RoutePath.root.path,
            builder: (_, __) => const SplashScreen(),
          ),
          GoRoute(
            name: RoutePath.signIn.name,
            path: RoutePath.signIn.path,
            builder: (_, __) => const SignInScreen(),
          ),
          GoRoute(
            name: RoutePath.home.name,
            path: RoutePath.home.path,
            builder: (_, __) => const HomeScreen(),
            routes: [
              GoRoute(
                name: RoutePath.surveyDetail.name,
                path: RoutePath.surveyDetail.path,
                builder: (_, state) => SurveyDetailScreen(
                  survey: (state.extra as SurveyModel),
                ),
              ),
              GoRoute(
                name: RoutePath.surveyQuestions.name,
                path: RoutePath.surveyQuestions.path,
                builder: (_, state) => SurveyQuestionsScreen(
                  surveyId: (state.params[surveyIdKey] as String),
                ),
              ),
            ],
          ),
        ],
      );
}
