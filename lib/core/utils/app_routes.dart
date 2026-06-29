import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/apply_screen.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/success_apply_screen.dart';
import 'package:flowery_rider_app/features/home/presentation/screens/home_screen.dart';
import 'package:flowery_rider_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/di/di.dart';
import '../../features/home/presentation/view_model/home_events.dart';
import '../../features/home/presentation/view_model/home_view_model.dart';
import '../../features/section_app/section_app.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutsName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutsName.applyScreen:
        return MaterialPageRoute(builder: (_) => const ApplyScreen());
      case AppRoutsName.successApplyScreen:
        return MaterialPageRoute(builder: (_) => const SuccessApplyScreen());
      case AppRoutsName.sectionApp:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
            getIt<HomeViewModel>()..doEvent(const LoadHomeDataEvent()),
            child: const SectionApp(),
          ),
        );
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
