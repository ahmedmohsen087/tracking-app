import 'package:flowery_rider_app/core/reusable_widgets/app_dialog.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/logout_events.dart';
import '../view_model/logout_view_model.dart';

class LogoutDialog {
  static Future<void> show(BuildContext context) {
    return AppDialog.show(
      context: context,
      title: AppStrings.logout,
      description: AppStrings.confirmLogout,
      confirmText: AppStrings.logout,
      cancelText: AppStrings.cancel,
      confirmButtonColor: AppColors.red,
      cancelButtonColor: AppColors.pink,
      barrierDismissible: false,
      onConfirm: () {
        context.read<LogoutViewModel>().doEvent(LogoutRequestEvent());
      },
    );
  }
}
