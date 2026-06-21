import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/apply_screen.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/success_apply_screen.dart';
import 'package:flowery_rider_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import '../../features/section_app/section_app.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutsName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutsName.sectionApp:
        return MaterialPageRoute(builder: (_) => const SectionApp());
      case AppRoutsName.applyScreen:
        return MaterialPageRoute(builder: (_) => const ApplyScreen());
      case AppRoutsName.successApplyScreen:
        return MaterialPageRoute(builder: (_) => const SuccessApplyScreen());
      case AppRoutsName.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
        );
    }
  }
}
