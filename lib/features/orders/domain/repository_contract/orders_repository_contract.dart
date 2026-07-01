import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/start_order_entity.dart';

abstract interface class OrdersRepositoryContract {
  Future<BaseResponse<StartOrderEntity>> startOrder(String orderId);
}
