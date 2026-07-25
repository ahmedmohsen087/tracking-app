import 'package:equatable/equatable.dart';

import 'order_product_entity.dart';

class DriverOrderItemEntity extends Equatable {
  final OrderProductEntity product;
  final int price;
  final int quantity;
  final String id;
  const DriverOrderItemEntity({
    required this.product,
    required this.price,
    required this.quantity,
    required this.id,
  });
 @override
 List<Object?> get props => [
   product,
   price,
   quantity,
   id,
 ];
  }
