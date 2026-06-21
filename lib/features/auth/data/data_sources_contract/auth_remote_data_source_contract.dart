import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/data/models/auth_response_model.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/apply_request_model.dart';

abstract interface class AuthRemoteDataSourceContract {
  Future<BaseResponse<AuthResponseModel>> login({
    required String email,
    required String password,
  });
  Future<BaseResponse<AuthResponseModel>> apply({
    required ApplyRequestModel requestModel,
  });
  Future<BaseResponse<AuthResponseModel>> logout();
}
