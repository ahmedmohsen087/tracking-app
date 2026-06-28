import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/login_request_model.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/auth/domain/mappers/auth_response_model_mapper.dart';
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
      case SuccessBaseResponse<AuthResponseModel>():
        final entity = response.data.toEntity();
        if (entity.token != null) {
          await _authManager.setAuthData(token: entity.token!);
        }
        return SuccessBaseResponse<AuthResponseEntity>(data: entity);
      case ErrorBaseResponse<AuthResponseModel>():
        return ErrorBaseResponse<AuthResponseEntity>(
          errorMessage: response.errorMessage,
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
      case SuccessBaseResponse<AuthResponseModel>():
        final entity = response.data.toEntity();
        return SuccessBaseResponse<AuthResponseEntity>(data: entity);
      case ErrorBaseResponse<AuthResponseModel>():
        return ErrorBaseResponse<AuthResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<AuthResponseEntity>> logout() async {
    final response = await _remoteDataSource.logout();
    switch (response) {
      case SuccessBaseResponse<AuthResponseModel>():
        return SuccessBaseResponse<AuthResponseEntity>(
          data: response.data.toEntity(),
        );
      case ErrorBaseResponse<AuthResponseModel>():
        return ErrorBaseResponse<AuthResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }
}
