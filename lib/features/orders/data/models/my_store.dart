import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/my_store_entity.dart';
part 'my_store.g.dart';
@JsonSerializable()
class MyStore {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "address")
  String? address;
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @JsonKey(name: "latLong")
  String? latLong;

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
      name: name ?? '',
      image: image ?? '',
      address: address ?? '',
      phoneNumber: phoneNumber ?? '',
      latLong: latLong ?? '',
    );
  }
}