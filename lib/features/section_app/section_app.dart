import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
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

  SvgPicture _icon(String asset, Color color) =>
      SvgPicture.asset(
        asset,
        height: 24,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );

  @override
  Widget build(BuildContext context) {
    context.locale;

    final List<Widget> pages = [
      HomeScreen(key: ValueKey('home_${context.locale.languageCode}')),
      OrdersScreen(key: ValueKey('orders_${context.locale.languageCode}')),
      BlocProvider(
        key: ValueKey('profile_${context.locale.languageCode}'),
        create: (context) => getIt<LogoutViewModel>(),
        child: const ProfileScreen(),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: currentTab.index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab.index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.pink,
        unselectedItemColor: AppColors.placeHolder,
        onTap: (index) {
          setState(() {
            currentTab = AppTab.values[index];
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _icon(Assets.assetsIconsHome, AppColors.placeHolder),
            activeIcon: _icon(Assets.assetsIconsHome, AppColors.pink),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: _icon(Assets.assetsIconsOrder, AppColors.placeHolder),
            activeIcon: _icon(Assets.assetsIconsOrder, AppColors.pink),
            label: AppStrings.orders,
          ),
          BottomNavigationBarItem(
            icon: _icon(Assets.assetsIconsPerson, AppColors.placeHolder),
            activeIcon: _icon(Assets.assetsIconsPerson, AppColors.pink),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}
