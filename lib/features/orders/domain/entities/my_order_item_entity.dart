import 'package:equatable/equatable.dart';

import 'my_product_entity.dart';

class MyOrderItemEntity extends Equatable{
 final MyProductEntity product;
 final int price;
 final int quantity;
 final String id;
  const MyOrderItemEntity({
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
