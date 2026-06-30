import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/my_product_entity.dart';
part 'my_product.g.dart';
@JsonSerializable()
class MyProduct {
  @JsonKey(name: "_id")
  Id? id;
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
      id: id ?? Id.THE_69_D988764461_DF0_F939_B5826,
      price: price ?? 0,
    );
  }
}

enum Id {
  @JsonValue("69d988764461df0f939b5826")
  THE_69_D988764461_DF0_F939_B5826,
  @JsonValue("69d988764461df0f939b5829")
  THE_69_D988764461_DF0_F939_B5829,
  @JsonValue("69d988774461df0f939b582f")
  THE_69_D988774461_DF0_F939_B582_F
}

enum PaymentType {
  @JsonValue("cash")
  CASH
}