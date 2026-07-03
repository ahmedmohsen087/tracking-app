import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/order_product_entity.dart';
part 'order_product.g.dart';
@JsonSerializable()
class OrderProduct {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "price")
  int? price;

  OrderProduct({
    this.id,
    this.price,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) => _$OrderProductFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
  OrderProductEntity toDomain (){
    return OrderProductEntity(
      id: id ?? '',
      price: price ?? 0,
    );
  }
}