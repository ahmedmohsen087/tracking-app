import '../entities/forget_password_entity.dart';
import '../entities/reset_password_entity.dart';
import '../entities/verify_otp_entity.dart';

abstract class AuthRepository {
  Future<void> forgetPassword(ForgetPasswordEntity entity);

  Future<void> verifyOtp(VerifyOtpEntity entity);

  Future<void> resetPassword(ResetPasswordEntity entity);
}