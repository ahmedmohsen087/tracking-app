import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/apply_screen.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:flowery_rider_app/features/auth/presentation/screens/success_apply_screen.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_driver_entity.dart';
import 'package:flowery_rider_app/features/profile/presentation/screens/change_password_screen.dart';
import 'package:flowery_rider_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:flowery_rider_app/features/profile/presentation/screens/edit_vehicle_info_screen.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_view_model.dart';
import 'package:flowery_rider_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/presentation/view_model/home_events.dart';
import '../../features/home/presentation/view_model/home_view_model.dart';
import '../../features/orders/presentation/view_models/my_orders_events.dart';
import '../../features/orders/presentation/view_models/my_orders_view_model.dart';
import '../../features/profile/presentation/view_models/get_profile_view_model/get_profile_event.dart';
import '../../features/profile/presentation/view_models/get_profile_view_model/get_profile_view_model.dart';
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

      case AppRoutsName.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutsName.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ForgetPasswordViewModel>(),
            child: const ForgetPasswordScreen(),
          ),
        );

      case AppRoutsName.emailVerificationScreen:
        final viewModel = settings.arguments as ForgetPasswordViewModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: viewModel,
            child: const EmailVerificationScreen(),
          ),
        );

      case AppRoutsName.resetPassword:
        final viewModel = settings.arguments as ForgetPasswordViewModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: viewModel,
            child: const ResetPasswordScreen(),
          ),
        );

      case AppRoutsName.sectionApp:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<HomeViewModel>()..doEvent(const LoadHomeDataEvent()),
              ),
              BlocProvider(
                create: (_) =>
                    getIt<GetProfileViewModel>()
                      ..doEvent(const RefreshProfileEvent()),
              ),
              BlocProvider(
                create: (_) => getIt<MyOrdersViewModel>()
                  ..doEvent(const LoadMyOrdersEvent()),
              ),
            ],
            child: const SectionApp(),
          ),
        );

      case AppRoutsName.changePasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ChangePasswordViewModel>(),
            child: Builder(builder: (context) => const ChangePasswordScreen()),
          ),
        );

      case AppRoutsName.editProfileScreen:
        final driver = settings.arguments as ProfileDriverEntity?;
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(driver: driver),
        );

      case AppRoutsName.editVehicleInfoScreen:
        final vehicleDriver = settings.arguments as ProfileDriverEntity?;
        return MaterialPageRoute(
          builder: (_) => EditVehicleInfoScreen(driver: vehicleDriver),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
        );
    }
  }
}
