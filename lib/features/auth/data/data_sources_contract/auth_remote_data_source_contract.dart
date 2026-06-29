import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/login_request_model.dart';
import 'package:flowery_rider_app/features/auth/data/models/auth_response_model.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/apply_request_model.dart';

abstract interface class AuthRemoteDataSourceContract {
  Future<BaseResponse<AuthResponseModel>> login({
    required LoginRequestModel loginRequestModel,
  });
  Future<BaseResponse<AuthResponseModel>> apply({
    required ApplyRequestModel applyRequestModel,
  });
  Future<BaseResponse<AuthResponseModel>> logout();
}
