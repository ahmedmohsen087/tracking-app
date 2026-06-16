import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/core/theme/app_theme.dart';
import 'package:flowery_rider_app/core/utils/app_routes.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutsName.sectionApp,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
