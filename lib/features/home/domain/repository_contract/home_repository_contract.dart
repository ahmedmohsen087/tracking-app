import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/get_orders_request.dart';
import '../entities/orders_page_entity.dart';

abstract class HomeRepositoryContract {
  Future<BaseResponse<OrdersPageEntity>> getOrders({
  required GetOrdersRequest request,
  });
}
