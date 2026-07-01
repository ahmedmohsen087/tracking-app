import 'package:dio/dio.dart';
import 'package:flowery_rider_app/features/orders/data/models/start_order_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'orders_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;

  @PUT('https://flower.elevateegy.com/api/v1/orders/start/{orderId}')
  Future<StartOrderResponse> startOrder(
    @Path('orderId') String orderId,
  );
}
