import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/reusable_widgets/app_snack_bar.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../auth/presentation/view_models/logout_view_model/logout_state.dart';
import '../../../auth/presentation/view_models/logout_view_model/logout_view_model.dart';


class LogoutWidget extends StatelessWidget {
  final Widget child;

  const LogoutWidget({
    super.key,
    required this.child,
  });

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
            builder: (_) =>
            const Center(child: CircularProgressIndicator()),
          );
          return;
        }

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        if (state.logoutState.msg == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutsName.loginScreen,
                (route) => false,
          );
        } else {
          AppSnackBar.showError(
            context,
            state.logoutState.msg!,
          );
        }
      },
      child: child,
    );
  }
}