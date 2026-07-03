import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/features/auth/presentation/flow/forget_password_routes.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowery_rider_app/config/di/di.dart';

class ForgetPasswordFlow extends StatelessWidget {
  const ForgetPasswordFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgetPasswordViewModel>(),
      child: Navigator(
        initialRoute: AppRoutsName.forgetPasswordScreen,
        onGenerateRoute: ForgetPasswordRoutes.onGenerateRoute,
      ),
    );
  }
}
