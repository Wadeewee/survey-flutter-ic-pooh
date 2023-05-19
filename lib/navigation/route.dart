import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';
import 'package:survey_flutter_ic/ui/detail/detail_screen.dart';
import 'package:survey_flutter_ic/ui/home/home_screen.dart';
import 'package:survey_flutter_ic/ui/signin/sign_in_screen.dart';
import 'package:survey_flutter_ic/ui/splash/splash_screen.dart';

enum RoutePath {
  root('/', '/'),
  home('/home', 'home'),
  signIn('/sign_in', 'sign_in'),
  detail('detail', 'detail');

  const RoutePath(this.path, this.name);

  final String path;
  final String name;
}

@Singleton()
class AppRouter {
  GoRouter router([String? initialLocation]) => GoRouter(
        initialLocation: initialLocation ?? RoutePath.root.path,
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
                name: RoutePath.detail.name,
                path: RoutePath.detail.path,
                builder: (_, state) => DetailScreen(
                  survey: (state.extra as SurveyModel),
                ),
              ),
            ],
          ),
        ],
      );
}
