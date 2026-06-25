import 'package:dio/dio.dart';
import 'package:flowery_rider_app/features/home/data/models/home_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../../../core/values/api_endpoints.dart';
part 'home_api_client.g.dart';
@lazySingleton
@RestApi()
abstract class HomeApiClient {
  @factoryMethod
  factory HomeApiClient(Dio dio) = _HomeApiClient;

  @GET(ApiEndpoints.pendingOrders)
  Future<HomeResponse> getOrders();

}
