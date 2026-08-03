import 'dart:async';

import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/config/secure_storage/secure_storage_service.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/assets.dart';
import 'package:flowery_rider_app/features/splash/presentation/widgets/circular_reveal_clipper.dart';
import 'package:flowery_rider_app/features/splash/presentation/widgets/onboarding_panel.dart';
import 'package:flowery_rider_app/features/splash/presentation/widgets/splash_branding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _heroHeight = 235.0;
  static const _heroScale = 2.2;

  late final AnimationController _logoController;
  late final AnimationController _revealController;
  late final AnimationController _heroController;
  late final AnimationController _contentController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _reveal;
  late final Animation<double> _heroLift;
  late final Animation<double> _contentOpacity;
  late final Animation<double> _contentTranslateY;

  final List<Timer> _timers = [];
  int _step = 0;

  late final Future<bool> _seenOnboardingFuture;

  @override
  void initState() {
    super.initState();
    _seenOnboardingFuture = getIt<SecureStorageService>().readSeenOnboarding();
    _initAnimations();
    _runTimeline();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0, 0.75, curve: Curves.ease),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Cubic(0.2, 0.85, 0.25, 1),
      ),
    );
    _reveal = CurvedAnimation(
      parent: _revealController,
      curve: const Cubic(0.66, 0, 0.34, 1),
    );
    _heroLift = CurvedAnimation(
      parent: _heroController,
      curve: const Cubic(0.2, 0.8, 0.25, 1),
    );
    _contentOpacity = CurvedAnimation(
      parent: _contentController,
      curve: Curves.ease,
    );
    _contentTranslateY = Tween<double>(begin: 22, end: 0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Cubic(0.2, 0.8, 0.25, 1),
      ),
    );
  }

  void _runTimeline() {
    _timers.add(
      Timer(const Duration(milliseconds: 180), () {
        if (!mounted) return;
        _logoController.forward();
      }),
    );
    _timers.add(
      Timer(const Duration(milliseconds: 1350), () {
        if (!mounted) return;
        setState(() => _step = 1);
        _revealController.forward();
      }),
    );
    _timers.add(
      Timer(const Duration(milliseconds: 4500), () {
        if (!mounted) return;
        _onHeroPhaseComplete();
      }),
    );
  }

  Future<void> _onHeroPhaseComplete() async {
    final seenOnboarding = await _seenOnboardingFuture;
    if (!mounted) return;

    if (getIt<AuthManager>().isLoggedIn) {
      Navigator.of(context).pushReplacementNamed(AppRoutsName.sectionApp);
      return;
    }

    if (seenOnboarding) {
      Navigator.of(context).pushReplacementNamed(AppRoutsName.loginScreen);
      return;
    }

    _goToOnboarding();
  }

  void _goToOnboarding() {
    if (!mounted) return;
    setState(() => _step = 2);
    _heroController.forward();
    _timers.add(
      Timer(const Duration(milliseconds: 120), () {
        if (!mounted) return;
        _contentController.forward();
      }),
    );
  }

  void _onLogin() {
    getIt<SecureStorageService>().writeSeenOnboarding(true);
    Navigator.of(context).pushReplacementNamed(AppRoutsName.loginScreen);
  }

  void _onApplyNow() {
    getIt<SecureStorageService>().writeSeenOnboarding(true);
    Navigator.of(context).pushReplacementNamed(AppRoutsName.applyScreen);
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _logoController.dispose();
    _revealController.dispose();
    _heroController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _step >= 1
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.pink,
        body: Stack(
          children: [
            _SplashBackgroundLayer(
              logoController: _logoController,
              logoOpacity: _logoOpacity,
              logoScale: _logoScale,
            ),
            _SplashRevealLayer(
              revealController: _revealController,
              heroController: _heroController,
              contentController: _contentController,
              reveal: _reveal,
              heroLift: _heroLift,
              contentOpacity: _contentOpacity,
              contentTranslateY: _contentTranslateY,
              step: _step,
              heroHeight: _heroHeight,
              heroScale: _heroScale,
              onLogin: _onLogin,
              onApplyNow: _onApplyNow,
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashBackgroundLayer extends StatelessWidget {
  const _SplashBackgroundLayer({
    required this.logoController,
    required this.logoOpacity,
    required this.logoScale,
  });

  final AnimationController logoController;
  final Animation<double> logoOpacity;
  final Animation<double> logoScale;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: logoController,
        builder: (context, _) => SplashBranding(
          opacity: logoOpacity.value,
          scale: logoScale.value,
        ),
      ),
    );
  }
}

class _SplashRevealLayer extends StatelessWidget {
  const _SplashRevealLayer({
    required this.revealController,
    required this.heroController,
    required this.contentController,
    required this.reveal,
    required this.heroLift,
    required this.contentOpacity,
    required this.contentTranslateY,
    required this.step,
    required this.heroHeight,
    required this.heroScale,
    required this.onLogin,
    required this.onApplyNow,
  });

  final AnimationController revealController;
  final AnimationController heroController;
  final AnimationController contentController;
  final Animation<double> reveal;
  final Animation<double> heroLift;
  final Animation<double> contentOpacity;
  final Animation<double> contentTranslateY;
  final int step;
  final double heroHeight;
  final double heroScale;
  final VoidCallback onLogin;
  final VoidCallback onApplyNow;

  static const _lottieAnimationWidget = _LottieAnimationWidget();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          revealController,
          heroController,
          contentController,
        ]),
        builder: (context, _) {
          final topFraction = 0.5 - 0.17 * heroLift.value;
          final heroTop = screenHeight * topFraction - heroHeight / 2;

          return ClipPath(
            clipper: CircularRevealClipper(progress: reveal.value),
            child: Container(
              color: AppColors.white,
              child: Stack(
                children: [
                  Positioned(
                    left: -65,
                    right: 0,
                    top: heroTop,
                    height: heroHeight,
                    child: Transform.scale(
                      scale: heroScale,
                      child: _lottieAnimationWidget,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      ignoring: step < 2,
                      child: OnboardingPanel(
                        opacity: contentOpacity.value,
                        translateY: contentTranslateY.value,
                        onLogin: onLogin,
                        onApplyNow: onApplyNow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LottieAnimationWidget extends StatelessWidget {
  const _LottieAnimationWidget();

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      Assets.assetsAnimationsOnboardingAnimation,
      fit: BoxFit.contain,
      repeat: true,
    );
  }
}
