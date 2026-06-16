import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../features/section_app/home_screen.dart';
import '../../features/section_app/orders_screen.dart';
import '../../features/section_app/profile_screen.dart';
import '../../features/section_app/section_app.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutsName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutsName.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutsName.ordersScreen:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case AppRoutsName.profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutsName.sectionApp:
        return MaterialPageRoute(builder: (_) => const SectionApp());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
        );
    }
  }
}
