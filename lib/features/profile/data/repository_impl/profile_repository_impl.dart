import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/profile/data/models/profile_response_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/mappers/profile_response_model_mapper.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository_contract/profile_repository_contract.dart';

@Injectable(as: ProfileRepositoryContract)
class ProfileRepositoryImpl implements ProfileRepositoryContract {
  final ProfileRemoteDataSourceContract _remoteDataSourceContract;
  final AuthManager _authManager;

  ProfileRepositoryImpl(this._remoteDataSourceContract, this._authManager);

  @override
  Future<BaseResponse<ProfileResponseEntity>> changePassword({
    required ProfileRequestModel requestModel,
  }) async {
    final response = await _remoteDataSourceContract.changePassword(
      request: requestModel,
    );

    switch (response) {
      case SuccessBaseResponse<ProfileResponseModel>():
        final entity = response.data.toEntity();
        if (entity.token != null) {
          await _authManager.setAuthData(token: entity.token!);
        }
        return SuccessBaseResponse<ProfileResponseEntity>(data: entity);
      case ErrorBaseResponse<ProfileResponseModel>():
        return ErrorBaseResponse<ProfileResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }
}
