import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/driver_order_item_entity.dart';
import '../../domain/entities/order_product_entity.dart';
import 'order_product.dart';

part 'driver_order_item.g.dart';

@JsonSerializable()
class DriverOrderItem {
  @JsonKey(name: "product")
  OrderProduct? product;
  @JsonKey(name: "price")
  int? price;
  @JsonKey(name: "quantity")
  int? quantity;
  @JsonKey(name: "_id")
  String? id;

  DriverOrderItem({
    this.product,
    this.price,
    this.quantity,
    this.id,
  });

  factory DriverOrderItem.fromJson(Map<String, dynamic> json) =>
      _$DriverOrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$DriverOrderItemToJson(this);

  DriverOrderItemEntity toDomain() {
    return DriverOrderItemEntity(
      product:
          product?.toDomain() ?? const OrderProductEntity(id: '', price: 0),
      price: price ?? 0,
      quantity: quantity ?? 0,
      id: id ?? '',
    );
  }
}