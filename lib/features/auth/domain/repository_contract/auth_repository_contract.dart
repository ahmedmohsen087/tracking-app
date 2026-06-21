import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/apply_request_model.dart';

abstract interface class AuthRepositoryContract {
  Future<BaseResponse<AuthResponseEntity>> login({
    required String email,
    required String password,
  });
  Future<BaseResponse<AuthResponseEntity>> apply({
    required ApplyRequestModel requestModel,
  });

  Future<BaseResponse<AuthResponseEntity>> logout();
}
