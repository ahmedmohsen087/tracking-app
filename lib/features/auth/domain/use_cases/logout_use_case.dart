import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase {
  final AuthRepositoryContract _logoutRepository;

  LogoutUseCase(this._logoutRepository);

  Future<BaseResponse<void>> execute() {
    return _logoutRepository.logout();
  }
}
