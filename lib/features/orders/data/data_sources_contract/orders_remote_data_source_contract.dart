import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/orders/data/models/get_order_response.dart';
import 'package:flowery_rider_app/features/orders/data/models/start_order_response.dart';

abstract interface class OrdersRemoteDataSourceContract {
  Future<BaseResponse<StartOrderResponse>> startOrder(String orderId);

  Future<BaseResponse<void>> updateOrderState(String orderId, String state);

  Future<BaseResponse<GetOrderResponse>> getDriverOrders({
    required int page,
    required int limit,
  });
}
