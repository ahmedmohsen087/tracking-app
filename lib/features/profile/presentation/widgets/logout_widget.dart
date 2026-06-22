import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/reusable_widgets/app_snack_bar.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../../auth/presentation/view_models/logout_view_model/logout_state.dart';
import '../../../auth/presentation/view_models/logout_view_model/logout_view_model.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutViewModel, LogoutState>(
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
              onPressed: () {
                final logoutViewModel = context.read<LogoutViewModel>();
                LogoutDialog.show(context, logoutViewModel);
              },
              child: Text(AppStrings.logout),
            ),
          ],
        ),
      ),
    );
  }
}
