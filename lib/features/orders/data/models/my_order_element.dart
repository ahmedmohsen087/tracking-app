import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/my_order_element_entity.dart';
import 'my_orders.dart';
import 'my_store.dart';
part 'my_orders_element.g.dart';
@JsonSerializable()
class MyOrderElement {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "driver")
  Driver? driver;
  @JsonKey(name: "order")
  MyOrders? order;
  @JsonKey(name: "__v")
  int? v;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @JsonKey(name: "store")
  MyStore? store;

  MyOrderElement({
    this.id,
    this.driver,
    this.order,
    this.v,
    this.createdAt,
    this.updatedAt,
    this.store,
  });

  factory MyOrderElement.fromJson(Map<String, dynamic> json) => _$MyOrderElementFromJson(json);

  Map<String, dynamic> toJson() => _$MyOrderElementToJson(this);
  MyOrderElementEntity toDomain (){
    return MyOrderElementEntity(
      id: id ?? '',
      driver: driver ?? Driver().toDomain(),
      order: order ?? MyOrders(),
      v: v ?? 0,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      store: store ?? MyStore(),
    );

  }
}

enum Driver {
  @JsonValue("6a2f643b992612ae599a87c5")
  THE_6_A2_F643_B992612_AE599_A87_C5
}