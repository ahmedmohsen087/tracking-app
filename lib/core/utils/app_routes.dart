import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';


import '../../features/forget_password/presentation/screens/forget_password_screen.dart';
import '../../features/forget_password/presentation/screens/verification_code_screen.dart';
import '../../features/section_app/section_app.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutsName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutsName.sectionApp:
        return MaterialPageRoute(builder: (_) => const SectionApp());
      case AppRoutsName.forgetPasswordScreen:
        return MaterialPageRoute(builder: (_) =>  ForgetPasswordScreen());
      case AppRoutsName.otpScreen:
        return MaterialPageRoute(builder: (_) =>  VerificationCodeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
        );
    }
  }
}
