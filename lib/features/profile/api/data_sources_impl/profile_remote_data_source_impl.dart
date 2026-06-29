import '../../data/data_sources_contract/profile_remote_data_source_contract.dart';
import '../profile_api_client/profile_api_client.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient profileApiClient;
  ProfileRemoteDataSourceImpl(this.profileApiClient);

  @override
  Future<BaseResponse<GetProfileResponse>> getProfile() async{

    try {
      final response = profileApiClient.getProfile();
      return SuccessBaseResponse<GetProfileResponse>(data: await response);
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<GetProfileResponse>(errorMessage: message);

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
    }

  }
}
