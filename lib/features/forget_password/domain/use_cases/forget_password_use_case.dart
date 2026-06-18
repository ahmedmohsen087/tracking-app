import '../entities/forget_password_entity.dart';
import '../repositories/auth_repository.dart';

class ForgetPasswordUseCase {
  final AuthRepository repository;

  ForgetPasswordUseCase(this.repository);

  Future<void> call(ForgetPasswordEntity entity) {
    return repository.forgetPassword(entity);
  }
}