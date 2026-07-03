import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/get_my_orders_request.dart';
import '../entities/get_order_response_entity.dart';

abstract  class OrdersRepositoryContract {
  Future<BaseResponse<GetOrderResponseEntity>> getMyOrders({
    required GetMyOrdersRequest request,
  });
}

