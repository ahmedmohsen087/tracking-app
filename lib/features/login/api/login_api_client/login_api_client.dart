import 'package:dio/dio.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:flowery_rider_app/core/values/api_endpoints.dart';
import 'package:flowery_rider_app/core/values/api_parameters.dart';
import 'package:flowery_rider_app/features/login/api/request_models/login_request_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'login_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class LoginApiClient {
  @factoryMethod
  factory LoginApiClient(Dio dio) = _LoginApiClient;

  @Extra({ApiParameters.requiresAuth: false})

  @POST(ApiEndpoints.login)
  Future<AuthResponse> login(@Body() LoginRequestModel body);
}
