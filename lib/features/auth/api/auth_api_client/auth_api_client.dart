import 'package:dio/dio.dart';
import 'package:flowery_rider_app/features/auth/data/models/auth_response_model.dart';
import 'package:flowery_rider_app/core/values/api_endpoints.dart';
import 'package:flowery_rider_app/core/values/api_parameters.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/login_request_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;
  @Extra({ApiParameters.requiresAuth: false})
  @POST(ApiEndpoints.login)
  Future<AuthResponseModel> login(@Body() LoginRequestModel body);

  @Extra({ApiParameters.requiresAuth: false})
  @POST(ApiEndpoints.applyDriver)
  @MultiPart()
  Future<AuthResponseModel> applyAsDriver(@Body() FormData formData);

  @GET(ApiEndpoints.logout)
  Future<AuthResponseModel> logout();
}
