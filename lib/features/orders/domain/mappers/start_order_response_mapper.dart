import 'package:flowery_rider_app/features/orders/data/models/start_order_response.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/start_order_entity.dart';

extension StartOrderDataMapper on StartOrderData {
  StartOrderEntity toEntity() {
    return StartOrderEntity(
      orderId: id ?? '',
      userId: user ?? '',
    );
  }
}
