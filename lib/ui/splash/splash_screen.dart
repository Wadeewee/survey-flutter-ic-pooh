import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_flutter_ic/gen/assets.gen.dart';
import 'package:survey_flutter_ic/navigation/route.dart';
import 'package:survey_flutter_ic/ui/splash/splash_view_model.dart';
import 'package:survey_flutter_ic/ui/splash/splash_widget_id.dart';

const _logoVisibilityDelayInMilliseconds = 500;
const _logoVisibilityAnimationInMilliseconds = 1000;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _logoVisible = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    Future.delayed(
        const Duration(milliseconds: _logoVisibilityDelayInMilliseconds), () {
      setState(() {
        ref.read(splashViewModelProvider.notifier).checkIsAuthorized();
        _logoVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAuthorized = ref.watch(isAuthorizedProvider).value ?? false;

    return Scaffold(
      body: Container(
        key: SplashWidgetId.background,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.images.bgSplash.path), fit: BoxFit.fill),
        ),
        child: Center(
          key: SplashWidgetId.logo,
          child: AnimatedOpacity(
            duration: const Duration(
                milliseconds: _logoVisibilityAnimationInMilliseconds),
            opacity: _logoVisible ? 1.0 : 0.0,
            child: Assets.images.icLogo.svg(),
            onEnd: () {
              if (isAuthorized) {
                context.goNamed(RoutePath.home.name);
              } else {
                context.goNamed(RoutePath.signIn.name);
              }
            },
          ),
        ),
      ),
    );
  }
}
