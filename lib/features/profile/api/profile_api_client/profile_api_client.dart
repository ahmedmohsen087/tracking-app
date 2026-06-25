import 'package:dio/dio.dart';
import 'package:flowery_rider_app/core/values/api_endpoints.dart';
import 'package:flowery_rider_app/core/values/api_parameters.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/data/models/profile_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;
  @Extra({ApiParameters.requiresAuth: false})
  @PATCH(ApiEndpoints.changePassword)
  Future<ProfileResponseModel> changePassword(@Body() ProfileRequestModel body);
}
