import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/get_order_response_entity.dart';
import 'meta_data.dart';
import 'my_order_element.dart';

part 'get_order_response.g.dart';

@JsonSerializable()
class GetOrderResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  Metadata? metadata;
  @JsonKey(name: "orders")
  List<MyOrderElement>? orders;

  GetOrderResponse({
    this.message,
    this.metadata,
    this.orders,
  });

  factory GetOrderResponse.fromJson(Map<String, dynamic> json) => _$GetOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetOrderResponseToJson(this);

  GetOrderResponseEntity toDomain() {
    return GetOrderResponseEntity(
      message: message ?? '',
      metadata: metadata?.toDomain() ?? Metadata().toDomain(),
      orders: orders?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}
















