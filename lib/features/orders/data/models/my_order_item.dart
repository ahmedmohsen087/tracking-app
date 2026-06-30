import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/my_order_item_entity.dart';
import 'my_product.dart';
part 'my_order_item.g.dart';
@JsonSerializable()
class MyOrderItem {
  @JsonKey(name: "product")
  MyProduct? product;
  @JsonKey(name: "price")
  int? price;
  @JsonKey(name: "quantity")
  int? quantity;
  @JsonKey(name: "_id")
  String? id;

  MyOrderItem({
    this.product,
    this.price,
    this.quantity,
    this.id,
  });

  factory MyOrderItem.fromJson(Map<String, dynamic> json) => _$MyOrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$MyOrderItemToJson(this);
  MyOrderItemEntity toDomain (){
    return MyOrderItemEntity(
      product: product ?? MyProduct(),
      price: price ?? 0,
      quantity: quantity ?? 0,
      id: id ?? '',
    );
  }
}