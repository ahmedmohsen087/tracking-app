import '../../domain/entities/forget_password_entity.dart';
import '../../domain/entities/reset_password_entity.dart';
import '../../domain/entities/verify_otp_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  @override
  Future<void> forgetPassword(ForgetPasswordEntity entity) async {

  }

  @override
  Future<void> verifyOtp(VerifyOtpEntity entity) async {

  }

  @override
  Future<void> resetPassword(ResetPasswordEntity entity) async {

  }
}