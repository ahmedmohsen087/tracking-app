import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/responses/edit_profile_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/upload_photo_response.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository_contract/profile_repository_contract.dart';
import '../data_sources_contract/profile_remote_data_source_contract.dart';

@Injectable(as: ProfileRepositoryContract)
class ProfileRepositoryImpl implements ProfileRepositoryContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<EditProfileResponseEntity>> editProfile({
    required EditProfileRequestModel requestModel,
  }) async {
    final response = await _remoteDataSource.editProfile(
      requestModel: requestModel,
    );

    switch (response) {
      case SuccessBaseResponse<EditProfileResponse>():
        final driver = response.data.driver?.toEntity();
        final entity = EditProfileResponseEntity(
          message: response.data.message,
          driver: driver,
        );
        return SuccessBaseResponse<EditProfileResponseEntity>(data: entity);
      case ErrorBaseResponse<EditProfileResponse>():
        return ErrorBaseResponse<EditProfileResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<String>> uploadPhoto({required String filePath}) async {
    final response = await _remoteDataSource.uploadPhoto(filePath: filePath);

    switch (response) {
      case SuccessBaseResponse<UploadPhotoResponse>():
        return SuccessBaseResponse<String>(
          data: response.data.message ?? '',
        );
      case ErrorBaseResponse<UploadPhotoResponse>():
        return ErrorBaseResponse<String>(
          errorMessage: response.errorMessage,
        );
    }
  }
}
