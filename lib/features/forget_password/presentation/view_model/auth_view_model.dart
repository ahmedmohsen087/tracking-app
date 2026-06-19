import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/forget_password_entity.dart';
import '../../domain/entities/reset_password_entity.dart';
import '../../domain/entities/verify_otp_entity.dart';
import '../../domain/use_cases/forget_password_use_case.dart';
import '../../domain/use_cases/reset_password_use_case.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';
import '../../../../core/utils/error/error_handler.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthCubit({
    required this.forgetPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial());

  Future<void> forgetPassword(String email) async {
    emit(ForgetPasswordLoading());

    try {
      await forgetPasswordUseCase(
        ForgetPasswordEntity(email: email),
      );

      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(ForgetPasswordError(ErrorHandler.handle(e)));
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    emit(VerifyOtpLoading());

    try {
      await verifyOtpUseCase(
        VerifyOtpEntity(
          email: email,
          otp: otp,
        ),
      );

      emit(VerifyOtpSuccess());
    } catch (e) {
      emit(VerifyOtpError(ErrorHandler.handle(e)));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String password,
  }) async {
    emit(ResetPasswordLoading());

    try {
      await resetPasswordUseCase(
        ResetPasswordEntity(
          email: email,
          newPassword: password,
        ),
      );

      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordError(ErrorHandler.handle(e)));
    }
  }
}