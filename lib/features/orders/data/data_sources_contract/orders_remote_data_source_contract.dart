import 'package:flowery_rider_app/features/orders/data/models/my_order_response.dart';
import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/get_my_orders_request.dart';

abstract interface class OrdersRemoteDataSourceContract {
  Future<BaseResponse<MyOrderResponse>> getMyOrders({
    required GetMyOrdersRequest request,
  });
}
