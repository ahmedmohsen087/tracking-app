import 'package:json_annotation/json_annotation.dart';
part 'start_order_response.g.dart';

@JsonSerializable()
class StartOrderResponse {
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'orders')
  StartOrderData? orders;

  StartOrderResponse({this.message, this.orders});

  factory StartOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$StartOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StartOrderResponseToJson(this);
}

@JsonSerializable()
class StartOrderData {
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'user')
  String? user;

  StartOrderData({this.id, this.user});

  factory StartOrderData.fromJson(Map<String, dynamic> json) =>
      _$StartOrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$StartOrderDataToJson(this);
}
