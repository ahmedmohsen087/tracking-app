import 'package:dio/dio.dart';
import 'package:flowery_rider_app/core/values/api_endpoints.dart';
import 'package:flowery_rider_app/features/apply/api/responses/apply_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'apply_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class ApplyApiClient {
  @factoryMethod
  factory ApplyApiClient(Dio dio) = _ApplyApiClient;

  @POST(ApiEndpoints.applyDriver)
  @MultiPart()

  // model reqquest ???
  Future<ApplyResponse> applyAsDriver(@Body() FormData formData);
}
