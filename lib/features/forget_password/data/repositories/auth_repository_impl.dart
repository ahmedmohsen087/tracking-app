import 'package:injectable/injectable.dart';
import '../../domain/entities/forget_password_entity.dart';
import '../../domain/entities/reset_password_entity.dart';
import '../../domain/entities/verify_otp_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../api/forget_password_api.dart';
import '../models/forget_password_model.dart';
import '../models/reset_password_model.dart';
import '../models/verify_otp_model.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final ForgetPasswordApi _api;

  AuthRepositoryImpl(this._api);

  @override
  Future<void> forgetPassword(ForgetPasswordEntity entity) async {
    await _api.forgetPassword(ForgetPasswordModel.fromEntity(entity));
  }

  @override
  Future<void> verifyOtp(VerifyOtpEntity entity) async {
    await _api.verifyOtp(VerifyOtpModel.fromEntity(entity));
  }

  @override
  Future<void> resetPassword(ResetPasswordEntity entity) async {
    await _api.resetPassword(ResetPasswordModel.fromEntity(entity));
  }
}