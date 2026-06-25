import 'package:dio/dio.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/utils/error/error_handler.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/responses/edit_profile_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/upload_photo_response.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_sources_contract/profile_remote_data_source_contract.dart';
import '../profile_api_client/profile_api_client.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient _profileApiClient;

  ProfileRemoteDataSourceImpl(this._profileApiClient);

  @override
  Future<BaseResponse<EditProfileResponse>> editProfile({
    required EditProfileRequestModel requestModel,
  }) async {
    try {
      final response = await _profileApiClient.editProfile(requestModel);
      return SuccessBaseResponse<EditProfileResponse>(data: response);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse<EditProfileResponse>(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<UploadPhotoResponse>> uploadPhoto({
    required String filePath,
  }) async {
    try {
      final multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      );
      final response = await _profileApiClient.uploadPhoto(multipartFile);
      return SuccessBaseResponse<UploadPhotoResponse>(data: response);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse<UploadPhotoResponse>(errorMessage: message);
    }
  }
}
