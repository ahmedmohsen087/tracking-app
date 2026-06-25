import 'package:flowery_rider_app/features/home/data/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/order_item_entity.dart';
part 'order_item.g.dart';
@JsonSerializable()
class OrderItem {
  @JsonKey(name: "product")
  Product? product;
  @JsonKey(name: "price")
  int? price;
  @JsonKey(name: "quantity")
  int? quantity;
  @JsonKey(name: "_id")
  String? id;

  OrderItem({
    this.product,
    this.price,
    this.quantity,
    this.id,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
  OrderItemEntity toDomain() {
    return OrderItemEntity(
      product: product?.toDomain(),
      price: price?.toDouble(),
      quantity: quantity,
      id: id,
    );
  }
}
