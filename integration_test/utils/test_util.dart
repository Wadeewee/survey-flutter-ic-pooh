import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:survey_flutter_ic/api/service/auth_service.dart';
import 'package:survey_flutter_ic/api/service/survey_service.dart';
import 'package:survey_flutter_ic/api/service/user_service.dart';
import 'package:survey_flutter_ic/database/persistence/hive_persistence.dart';
import 'package:survey_flutter_ic/di/provider/di.dart';
import 'package:survey_flutter_ic/navigation/route.dart';

import '../fake_data/fake_services/fake_auth_service.dart';
import '../fake_data/fake_services/fake_survey_service.dart';
import '../fake_data/fake_services/fake_user_service.dart';

class TestUtil {
  /// We normally use this function to test a specific [widget] without
  /// considering much about theming.
  static Widget pumpWidgetWithShellApp(Widget widget) {
    _initDependencies();
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ProviderScope(child: widget),
    );
  }

  static Widget pumpWidgetWithRoutePath(String route, {Object? extraBundle}) {
    _initDependencies();

    final router = getIt.get<AppRouter>().router(route, extraBundle);

    return ProviderScope(
        child: MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    ));
  }

  static void _initDependencies() {
    PackageInfo.setMockInitialValues(
        appName: 'Flutter IC testing',
        packageName: '',
        version: '',
        buildNumber: '',
        buildSignature: '',
        installerStore: '');

    FlutterConfig.loadValueForTesting({
      'CLIENT_ID': 'CLIENT_ID',
      'CLIENT_SECRET': 'CLIENT_SECRET',
      'REST_API_ENDPOINT': 'REST_API_ENDPOINT',
    });
  }

  static Future setupTestEnvironment() async {
    _initDependencies();
    await initHivePersistence();
    await configureInjection();

    getIt.allowReassignment = true;
    getIt.registerSingleton<AuthService>(FakeAuthService());
    getIt.registerSingleton<UserService>(FakeUserService());
    getIt.registerSingleton<SurveyService>(FakeSurveyService());
  }
}
