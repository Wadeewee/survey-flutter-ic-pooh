import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_flutter_ic/database/persistence/hive_persistence.dart';
import 'package:survey_flutter_ic/di/provider/di.dart';
import 'package:survey_flutter_ic/navigation/route.dart';
import 'package:survey_flutter_ic/theme/app_color_scheme.dart';
import 'package:survey_flutter_ic/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await initHivePersistence();
  await configureInjection();

  final router = getIt.get<AppRouter>().router();
  runApp(ProviderScope(child: MyApp(router: router)));
}

class MyApp extends ConsumerWidget {
  final GoRouter router;

  const MyApp({
    Key? key,
    required this.router,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MaterialApp.router(
        theme: AppTheme.theme(AppColorScheme.light()),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
      ),
    );
  }
}
