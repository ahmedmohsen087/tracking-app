import 'package:injectable/injectable.dart';
import '../entities/verify_otp_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<void> call(VerifyOtpEntity entity) {
    return repository.verifyOtp(entity);
  }
}