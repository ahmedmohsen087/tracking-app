import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/orders/api/request_models/get_driver_orders_request.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/get_order_response_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/start_order_entity.dart';

abstract interface class OrdersRepositoryContract {
  Future<BaseResponse<StartOrderEntity>> startOrder(String orderId);

  Future<BaseResponse<void>> updateOrderState(String orderId, String state);

  Future<BaseResponse<GetOrderResponseEntity>> getDriverOrders({
    required GetDriverOrdersRequest request,
  });
}
