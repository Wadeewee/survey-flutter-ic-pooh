import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:survey_flutter_ic/ui/home/home_screen.dart';
import 'package:survey_flutter_ic/ui/signin/sign_in_screen.dart';
import 'package:survey_flutter_ic/ui/splash/splash_screen.dart';

enum RoutePath {
  root('/', '/'),
  home('/home', 'home'),
  signIn('/sign_in', 'sign_in');

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
            name: RoutePath.home.name,
            path: RoutePath.home.path,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            name: RoutePath.signIn.name,
            path: RoutePath.signIn.path,
            builder: (_, __) => const SignInScreen(),
          ),
        ],
      );
}
