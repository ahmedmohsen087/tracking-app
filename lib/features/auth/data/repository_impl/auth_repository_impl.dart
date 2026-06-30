import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/login_request_model.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:flowery_rider_app/features/auth/domain/mappers/auth_response_model_mapper.dart'; // المابير الموحد اللي عدلناه سوا
import 'package:flowery_rider_app/features/auth/data/models/auth_response_model.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/apply_request_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository_contract/auth_repository_contract.dart';
import '../data_sources_contract/auth_remote_data_source_contract.dart';

@Injectable(as: AuthRepositoryContract)
class AuthRepositoryImpl implements AuthRepositoryContract {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthManager _authManager;
  AuthRepositoryImpl(this._remoteDataSource, this._authManager);

  @override
  Future<BaseResponse<AuthResponseEntity>> login({
    required LoginRequestModel loginRequestModel,
  }) async {
    final response = await _remoteDataSource.login(
      loginRequestModel: loginRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<AuthResponseModel>(data: final data):
        final entity = data.toEntity();
        if (entity.token != null) {
          await _authManager.setAuthData(token: entity.token!);
        }
        return SuccessBaseResponse<AuthResponseEntity>(data: entity);
      case ErrorBaseResponse<AuthResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<AuthResponseEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<AuthResponseEntity>> apply({
    required ApplyRequestModel applyRequestModel,
  }) async {
    final response = await _remoteDataSource.apply(
      applyRequestModel: applyRequestModel,
    );

    switch (response) {
      case SuccessBaseResponse<AuthResponseModel>(data: final data):
        final entity = data.toEntity();
        return SuccessBaseResponse<AuthResponseEntity>(data: entity);
      case ErrorBaseResponse<AuthResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<AuthResponseEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<AuthResponseEntity>> logout() async {
    final response = await _remoteDataSource.logout();
    switch (response) {
      case SuccessBaseResponse<AuthResponseModel>(data: final data):
        return SuccessBaseResponse<AuthResponseEntity>(data: data.toEntity());
      case ErrorBaseResponse<AuthResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<AuthResponseEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    final response = await _remoteDataSource.forgetPassword(
      forgetPasswordRequestModel: forgetPasswordRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<AuthResponseModel>(data: final data):
        return SuccessBaseResponse<ForgetPasswordEntity>(
          data: data.toForgetPasswordEntity(
            step: ForgetPasswordRecoveryStep.forget,
          ),
        );
      case ErrorBaseResponse<AuthResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ForgetPasswordEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> verifyOtp({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    final response = await _remoteDataSource.verifyOtp(
      forgetPasswordRequestModel: forgetPasswordRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<AuthResponseModel>(data: final data):
        return SuccessBaseResponse<ForgetPasswordEntity>(
          data: data.toForgetPasswordEntity(
            step: ForgetPasswordRecoveryStep.verify,
          ),
        );
      case ErrorBaseResponse<AuthResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ForgetPasswordEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    final response = await _remoteDataSource.resetPassword(
      forgetPasswordRequestModel: forgetPasswordRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<AuthResponseModel>(data: final data):
        return SuccessBaseResponse<ForgetPasswordEntity>(
          data: data.toForgetPasswordEntity(
            step: ForgetPasswordRecoveryStep.reset,
          ),
        );
      case ErrorBaseResponse<AuthResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ForgetPasswordEntity>(
          errorMessage: errorMessage,
        );
    }
  }
}
