import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/config/firebase/firebase_service.dart';
import 'package:flowery_rider_app/features/orders/data/services/background_location_service.dart';
import 'package:flowery_rider_app/my_app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  await BackgroundLocationService.initialize();
  await EasyLocalization.ensureInitialized();
  await configureDependencies();
  await getIt<AuthManager>().init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}
