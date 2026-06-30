import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../../../core/values/api_endpoints.dart';
import '../../data/models/my_order_response.dart';
part 'orders_api_client.g.dart';
@lazySingleton
@RestApi()
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;


  @GET(ApiEndpoints.myOrders)
  Future<MyOrderResponse> getMyOrders({
    @Query('page') required int page,
    @Query('limit') required int limit,
  });

}
