import '../entities/reset_password_entity.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call(ResetPasswordEntity entity) {
    return repository.resetPassword(entity);
  }
}