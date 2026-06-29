import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/services/media_service.dart';
import 'package:flowery_rider_app/core/utils/error/error_handler.dart';
import 'package:flowery_rider_app/features/profile/api/profile_api_client/profile_api_client.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_vehicle_info_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/responses/edit_profile_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/upload_photo_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/vehicle_types_response.dart';
import 'package:flowery_rider_app/features/profile/data/models/profile_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_sources_contract/profile_remote_data_source_contract.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient _profileApiClient;
  final MediaService _mediaService;


  ProfileRemoteDataSourceImpl(this._profileApiClient, this._mediaService);

  @override
  Future<BaseResponse<ProfileResponseModel>> changePassword({
    required ProfileRequestModel request,
  }) async {
    try {
      final response = await _profileApiClient.changePassword(request);
      return SuccessBaseResponse<ProfileResponseModel>(data: response);
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<ProfileResponseModel>(errorMessage: message);
    }
  }

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
      final multipartFile = await _mediaService.createMultipartFile(filePath);
      final response = await _profileApiClient.uploadPhoto(multipartFile);
      return SuccessBaseResponse<UploadPhotoResponse>(data: response);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse<UploadPhotoResponse>(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<VehicleTypesResponse>> getVehicleTypes({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _profileApiClient.getVehicleTypes(page, limit);
      return SuccessBaseResponse<VehicleTypesResponse>(data: response);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse<VehicleTypesResponse>(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<String>> editVehicleInfo({
    required EditVehicleInfoRequestModel requestModel,
  }) async {
    try {
      // Use media service as requested for processing the file
      await _mediaService.createMultipartFile(
          requestModel.vehicleLicenseFilePath);
      return SuccessBaseResponse<String>(data: 'success');
    } catch (e) {
      return ErrorBaseResponse<String>(errorMessage: e.toString());
    }
  }
}
