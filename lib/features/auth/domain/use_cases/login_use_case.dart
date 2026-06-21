import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:injectable/injectable.dart';
import '../../api/request_models/login_request_model.dart';
import '../repository_contract/auth_repository_contract.dart';

@injectable
class LoginUseCase {
  final AuthRepositoryContract _loginRepository;

  LoginUseCase(this._loginRepository);

  Future<BaseResponse<AuthResponseEntity>> execute({
    required LoginRequestModel requestModel,
  }) {
    return _loginRepository.login(
      email: requestModel.email,
      password: requestModel.password,
    );
  }
}
