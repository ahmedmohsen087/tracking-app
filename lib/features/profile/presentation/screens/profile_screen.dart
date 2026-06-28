import 'package:flowery_rider_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/logout_view_model/logout_state.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/logout_view_model/logout_view_model.dart';
import 'package:flowery_rider_app/features/auth/presentation/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profile)),
      body: BlocListener<LogoutViewModel, LogoutState>(
        listenWhen: (previous, current) =>
            previous.logoutState != current.logoutState,
        listener: (context, state) {
          if (state.logoutState.isLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
          }

          if (!state.logoutState.isLoading && state.logoutState.msg == null) {
            if (Navigator.canPop(context)) Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutsName.loginScreen,
              (route) => false,
            );
          } else if (state.logoutState.msg != null) {
            if (Navigator.canPop(context)) Navigator.pop(context);
            AppSnackBar.showError(context, state.logoutState.msg!);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutsName.editProfileScreen,
                ),
                child: Text(AppStrings.editProfile),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutsName.editVehicleInfoScreen,
                ),
                child: Text(AppStrings.editVehicleInfo),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final logoutViewModel = context.read<LogoutViewModel>();
                  LogoutDialog.show(context, logoutViewModel);
                },
                child: Text(AppStrings.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
