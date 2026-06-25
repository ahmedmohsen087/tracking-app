import 'package:dio/dio.dart';
import 'package:flowery_rider_app/core/values/api_endpoints.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/responses/edit_profile_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/upload_photo_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @PUT(ApiEndpoints.editProfile)
  Future<EditProfileResponse> editProfile(@Body() EditProfileRequestModel body);

  @PUT(ApiEndpoints.uploadPhoto)
  @MultiPart()
  Future<UploadPhotoResponse> uploadPhoto(
    @Part(name: 'photo') MultipartFile photo,
  );
}
