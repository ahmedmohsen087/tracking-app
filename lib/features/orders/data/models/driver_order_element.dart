import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/driver_order_element_entity.dart';
import 'driver_orders.dart';
import 'my_store.dart';

part 'driver_order_element.g.dart';

@JsonSerializable()
class DriverOrderElement {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "driver")
  String? driver;
  @JsonKey(name: "order")
  DriverOrders? order;
  @JsonKey(name: "__v")
  int? v;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @JsonKey(name: "store")
  MyStore? store;

  DriverOrderElement({
    this.id,
    this.driver,
    this.order,
    this.v,
    this.createdAt,
    this.updatedAt,
    this.store,
  });

  factory DriverOrderElement.fromJson(Map<String, dynamic> json) =>
      _$DriverOrderElementFromJson(json);

  Map<String, dynamic> toJson() => _$DriverOrderElementToJson(this);

  DriverOrderElementEntity toDomain() {
    return DriverOrderElementEntity(
      id: id ?? '',
      driver: driver ?? '',
      order: order?.toDomain() ?? const DriverOrders().toDomain(),
      v: v ?? 0,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      store: store?.toDomain() ?? MyStore().toDomain(),
    );
  }
}