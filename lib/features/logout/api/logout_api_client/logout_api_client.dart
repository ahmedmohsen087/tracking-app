import 'package:dio/dio.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:flowery_rider_app/core/values/endpoints.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'logout_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class LogoutApiClient {
  @factoryMethod
  factory LogoutApiClient(Dio dio) = _LogoutApiClient;

  @POST(Endpoints.logout)
  Future<BaseResponse<AuthResponse>> logout();
}
