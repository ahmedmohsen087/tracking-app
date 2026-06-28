import 'package:flutter/material.dart';

import '../../core/values/app_strings.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

enum AppTab {
  home,
  orders,
  profile,
}

class SectionApp extends StatefulWidget {
  const SectionApp({super.key});

  @override
  State<SectionApp> createState() => _SectionAppState();
}

class _SectionAppState extends State<SectionApp> {
  AppTab currentTab = AppTab.home;

  final List<Widget> pages = const [
    HomeScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentTab.index,
        children: pages,
      ),
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
            icon: const Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: AppStrings.orders,
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}