import '../../../../config/base_response/base_response.dart';
import '../entities/order_entity.dart';

abstract class HomeRepositoryContract {
  Future<BaseResponse<List<OrderEntity>>> getOrders();
}