import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/order_shipping_address_entity.dart';
part 'order_shipping_address.g.dart';
@JsonSerializable()
class OrderShippingAddress {
  @JsonKey(name: "street")
  String? street;
  @JsonKey(name: "city")
  String? city;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "lat")
  String? lat;
  @JsonKey(name: "long")
  String? long;

  OrderShippingAddress({
    this.street,
    this.city,
    this.phone,
    this.lat,
    this.long,
  });

  factory OrderShippingAddress.fromJson(Map<String, dynamic> json) => _$OrderShippingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$OrderShippingAddressToJson(this);

  OrderShippingAddressEntity toDomain(){
    return OrderShippingAddressEntity(
      street: street ?? '',
      city: city ?? '',
      phone: phone ?? '',
      lat: lat ?? '',
      long: long ?? '',
    );
  }
}

enum State {
  @JsonValue("completed")
  COMPLETED,
  @JsonValue("inProgress")
  IN_PROGRESS ,


}
