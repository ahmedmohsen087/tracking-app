import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/my_order_response_entity.dart';
import 'meta_data.dart';
import 'my_order_element.dart';

part 'my_order_response.g.dart';

@JsonSerializable()
class MyOrderResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  Metadata? metadata;
  @JsonKey(name: "orders")
  List<MyOrderElement>? orders;

  MyOrderResponse({
    this.message,
    this.metadata,
    this.orders,
  });

  factory MyOrderResponse.fromJson(Map<String, dynamic> json) => _$MyOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyOrderResponseToJson(this);

  MyOrderResponseEntity toDomain() {
    return MyOrderResponseEntity(
      message: message ?? '',
      metadata: metadata?.toDomain() ?? Metadata().toDomain(),
      orders: orders?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}
















