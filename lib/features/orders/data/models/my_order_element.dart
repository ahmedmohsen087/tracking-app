import 'package:json_annotation/json_annotation.dart';

import '../../../auth/data/models/driver_model.dart';
import '../../domain/entities/my_order_element_entity.dart';
import 'my_orders.dart';
import 'my_store.dart';

part 'my_order_element.g.dart';

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
      driver: driver?.toDomain() ?? Driver().toDomain(),
      order: order?.toDomain() ?? MyOrders().toDomain(),
      v: v ?? 0,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      store: store?.toDomain() ?? MyStore().toDomain(),
    );
  }
}