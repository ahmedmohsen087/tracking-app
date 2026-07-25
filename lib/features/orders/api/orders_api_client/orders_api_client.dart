import 'package:dio/dio.dart';
import 'package:flowery_rider_app/core/values/api_endpoints.dart';
import 'package:flowery_rider_app/core/values/api_parameters.dart';
import 'package:flowery_rider_app/features/orders/data/models/get_order_response.dart';
import 'package:flowery_rider_app/features/orders/data/models/start_order_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'orders_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;

  @PUT('${ApiEndpoints.startOrder}/{orderId}')
  Future<StartOrderResponse> startOrder(
    @Path(ApiParameters.orderId) String orderId,
  );

  @PUT('${ApiEndpoints.orderState}/{orderId}')
  Future<void> updateOrderState(
    @Path(ApiParameters.orderId) String orderId,
    @Body() Map<String, dynamic> body,
  );

  @GET(ApiEndpoints.myOrders)
  Future<GetOrderResponse> getDriverOrders(
    @Query('page') int page,
    @Query('limit') int limit,
  );
}
