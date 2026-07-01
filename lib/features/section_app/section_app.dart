import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/logout_view_model/logout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/values/app_strings.dart';
import '../../core/values/assets.dart';
import '../home/presentation/screens/home_screen.dart';
import '../orders/presentation/screens/orders_screen.dart';
import '../profile/presentation/screens/profile_screen.dart';

enum AppTab { home, orders, profile }

class SectionApp extends StatefulWidget {
  const SectionApp({super.key});

  @override
  State<SectionApp> createState() => _SectionAppState();
}

class _SectionAppState extends State<SectionApp> {
  AppTab currentTab = AppTab.home;

  final List<Widget> pages = [
    const HomeScreen(),
    const OrdersScreen(),
    BlocProvider(
      create: (context) => getIt<LogoutViewModel>(),
      child: const ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentTab.index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab.index,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentTab = AppTab.values[index];
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.assetsIconsHome, height: 24),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.assetsIconsOrder, height: 24),
            label: AppStrings.orders,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.assetsIconsPerson, height: 24),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}
