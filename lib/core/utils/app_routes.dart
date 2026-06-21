import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/apply/presentation/screens/apply_screen.dart';
import 'package:flowery_rider_app/features/apply/presentation/screens/success_apply_screen.dart';
import 'package:flowery_rider_app/features/login/presentation/screens/login_screen.dart';
import 'package:flowery_rider_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/features/forget_password/presentation/view_model/auth_view_model.dart';
import '../../features/forget_password/presentation/screens/forget_password_screen.dart';
import '../../features/forget_password/presentation/screens/reset_password.dart';
import '../../features/forget_password/presentation/screens/verification_code_screen.dart';
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
      case AppRoutsName.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: ForgetPasswordScreen(),
          ),
        );
      case AppRoutsName.otpScreen:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: VerificationCodeScreen(email: email),
          ),
        );
      case AppRoutsName.resetPassword:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: ResetPassword(email: email),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
        );
    }
  }
}
