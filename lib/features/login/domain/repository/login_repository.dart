import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/entities/auth_response_entity.dart';

abstract interface class LoginRepository {
  Future<BaseResponse<AuthResponseEntity>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });
}
