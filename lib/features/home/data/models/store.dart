import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable()
class Store {
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

  Store({this.name, this.image, this.address, this.phoneNumber, this.latLong});

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
