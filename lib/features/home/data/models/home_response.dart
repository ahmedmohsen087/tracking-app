import 'package:json_annotation/json_annotation.dart';

import 'metadata.dart';
import 'home_order.dart';
part 'home_response.g.dart';

@JsonSerializable()
class HomeResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  Metadata? metadata;
  @JsonKey(name: "orders")
  List<HomeOrder>? orders;

  HomeResponse({this.message, this.metadata, this.orders});

  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeResponseToJson(this);
}
