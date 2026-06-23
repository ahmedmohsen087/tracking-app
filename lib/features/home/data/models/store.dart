import 'package:json_annotation/json_annotation.dart';
part 'store.g.dart';
@JsonSerializable()
class Store {
  @JsonKey(name: "name")
  Name? name;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "address")
  Address? address;
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @JsonKey(name: "latLong")
  LatLong? latLong;

  Store({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

enum Address {
  @JsonValue("123 Fixed Address, City, Country")
  THE_123_FIXED_ADDRESS_CITY_COUNTRY
}

enum LatLong {
  @JsonValue("37.7749,-122.4194")
  THE_3777491224194
}

enum Name {
  @JsonValue("Elevate FlowerApp Store")
  ELEVATE_FLOWER_APP_STORE
}