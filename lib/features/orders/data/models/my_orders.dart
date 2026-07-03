import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/my_orders_entity.dart';
import 'my_order_item.dart';
import 'order_shipping_address.dart';
import 'order_users.dart';

part 'my_orders.g.dart';

@JsonSerializable()
class MyOrders {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "user")
  final OrderUsers? user;

  @JsonKey(name: "orderItems")
  final List<MyOrderItem>? orderItems;

  @JsonKey(name: "totalPrice")
  final double? totalPrice;

  @JsonKey(name: "shippingAddress")
  final OrderShippingAddress? shippingAddress;

  @JsonKey(name: "paymentType")
  final PaymentType? paymentType;

  @JsonKey(name: "isPaid")
  final bool? isPaid;

  @JsonKey(name: "paidAt")
  final DateTime? paidAt;

  @JsonKey(name: "isDelivered")
  final bool? isDelivered;

  @JsonKey(name: "state")
  final OrderState? state;

  @JsonKey(name: "createdAt")
  final DateTime? createdAt;

  @JsonKey(name: "updatedAt")
  final DateTime? updatedAt;

  @JsonKey(name: "orderNumber")
  final String? orderNumber;

  @JsonKey(name: "__v")
  final int? v;

  const MyOrders({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.shippingAddress,
    this.paymentType,
    this.isPaid,
    this.paidAt,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
  });

  factory MyOrders.fromJson(Map<String, dynamic> json) =>
      _$MyOrdersFromJson(json);

  Map<String, dynamic> toJson() => _$MyOrdersToJson(this);

  MyOrdersEntity toDomain() {
    return MyOrdersEntity(
      id: id ?? '',
      user: user?.toDomain() ?? OrderUsers().toDomain(),
      orderItems: orderItems?.map((e) => e.toDomain()).toList() ?? [],
      totalPrice: totalPrice ?? 0,
      shippingAddress:
      shippingAddress?.toDomain() ?? OrderShippingAddress().toDomain(),
      paymentType: paymentType ?? PaymentType.cash,
      isPaid: isPaid ?? false,
      paidAt: paidAt ?? DateTime.now(),
      isDelivered: isDelivered ?? false,
      state: state ?? OrderState.inProgress,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      v: v ?? 0,
      orderNumber: orderNumber ?? '',
    );
  }
}