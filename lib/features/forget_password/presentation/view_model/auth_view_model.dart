import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/forget_password_entity.dart';
import '../../domain/entities/reset_password_entity.dart';
import '../../domain/entities/verify_otp_entity.dart';
import '../../domain/use_cases/forget_password_use_case.dart';
import '../../domain/use_cases/reset_password_use_case.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';
import 'auth_state.dart';


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
    emit(AuthLoading());

    try {
      await forgetPasswordUseCase(
        ForgetPasswordEntity(email: email),
      );

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    emit(AuthLoading());

    try {
      await verifyOtpUseCase(
        VerifyOtpEntity(
          email: email,
          otp: otp,
        ),
      );

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      await resetPasswordUseCase(
        ResetPasswordEntity(
          email: email,
          newPassword: password,
        ),
      );

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}