import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../../core/values/api_endpoints.dart';
import '../../data/models/get_profile_response.dart';
part 'profile_api_client.g.dart';
@injectable
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;


  @GET(ApiEndpoints.profile)
Future<GetProfileResponse> getProfile() ;

}
