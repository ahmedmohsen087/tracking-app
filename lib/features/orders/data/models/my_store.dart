import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/my_store_entity.dart';
part 'my_store.g.dart';
@JsonSerializable()
class MyStore {
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

  MyStore({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });

  factory MyStore.fromJson(Map<String, dynamic> json) => _$MyStoreFromJson(json);

  Map<String, dynamic> toJson() => _$MyStoreToJson(this);
  MyStoreEntity toDomain (){
    return MyStoreEntity(
      name: name ?? Name.ELEVATE_FLOWER_APP_STORE,
      image: image ?? '',
      address: address ?? Address.THE_123_FIXED_ADDRESS_CITY_COUNTRY,
      phoneNumber: phoneNumber ?? '',
      latLong: latLong ?? LatLong.THE_3777491224194,
    );

  }
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