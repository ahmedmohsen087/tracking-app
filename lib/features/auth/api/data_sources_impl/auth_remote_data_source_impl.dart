import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/data/models/auth_response_model.dart';
import 'package:flowery_rider_app/core/utils/error/error_handler.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/login_request_model.dart';
import 'package:injectable/injectable.dart';
import '../../data/data_sources_contract/auth_remote_data_source_contract.dart';
import '../auth_api_client/auth_api_client.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<BaseResponse<AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authApiClient.login(
        LoginRequestModel(email: email, password: password),
      );
      return SuccessBaseResponse<AuthResponseModel>(data: response);
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<AuthResponseModel>(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<AuthResponseModel>> apply({
    required ApplyRequestModel requestModel,
  }) async {
    try {
      final response = await _authApiClient.applyAsDriver(
        await requestModel.toFormData(),
      );
      return SuccessBaseResponse(data: response);
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<AuthResponseModel>> logout() async {
    try {
      final response = _authApiClient.logout();
      return SuccessBaseResponse<AuthResponseModel>(data: await response);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse<AuthResponseModel>(errorMessage: message);
    }
  }
}
