import '../../../../config/base_response/base_response.dart';
import '../entities/orders_page_entity.dart';

abstract class HomeRepositoryContract {
  Future<BaseResponse<OrdersPageEntity>> getOrders({
    required int page,
    required int limit,
  });
}
