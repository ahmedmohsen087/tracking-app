import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/shipping_address_entity.dart';
part 'shipping_address.g.dart';
@JsonSerializable()
class ShippingAddress {
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

  ShippingAddress({
    this.street,
    this.city,
    this.phone,
    this.lat,
    this.long,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => _$ShippingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
  ShippingAddressEntity toDomain(){
    return ShippingAddressEntity(
      street: street,
      city: city,
      phone: phone,
      lat: lat,
      long: long,
    );
  }
}

enum State {
  @JsonValue("pending")
  PENDING
}