import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/my_product_entity.dart';
part 'my_product.g.dart';
@JsonSerializable()
class MyProduct {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "price")
  int? price;

  MyProduct({
    this.id,
    this.price,
  });

  factory MyProduct.fromJson(Map<String, dynamic> json) => _$MyProductFromJson(json);

  Map<String, dynamic> toJson() => _$MyProductToJson(this);
  MyProductEntity toDomain (){
    return MyProductEntity(
      id: id ?? '',
      price: price ?? 0,
    );
  }
}