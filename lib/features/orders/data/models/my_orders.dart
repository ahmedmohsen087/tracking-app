import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/my_orders_entity.dart';
import 'my_order_item.dart';
import 'my_users.dart';
import 'order_shipping_address.dart';

part 'my_orders.g.dart';

enum PaymentTypeModel {
  @JsonValue("cash")
  cash,
}

enum OrderStateModel {
  @JsonValue("completed")
  completed,
  @JsonValue("inProgress")
  inProgress,
  @JsonValue("cancelled")
  cancelled,
}

@JsonSerializable()
class MyOrders {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "user")
  MyUsers? user;
  @JsonKey(name: "orderItems")
  List<MyOrderItem>? orderItems;
  @JsonKey(name: "totalPrice")
  double? totalPrice;
  @JsonKey(name: "shippingAddress")
  OrderShippingAddress? shippingAddress;
  @JsonKey(name: "paymentType")
  PaymentTypeModel? paymentType;
  @JsonKey(name: "isPaid")
  bool? isPaid;
  @JsonKey(name: "paidAt")
  DateTime? paidAt;
  @JsonKey(name: "isDelivered")
  bool? isDelivered;
  @JsonKey(name: "state")
  OrderStateModel? state;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @JsonKey(name: "orderNumber")
  String? orderNumber;
  @JsonKey(name: "__v")
  int? v;

  MyOrders({
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

  factory MyOrders.fromJson(Map<String, dynamic> json) => _$MyOrdersFromJson(json);

  Map<String, dynamic> toJson() => _$MyOrdersToJson(this);

  MyOrdersEntity toDomain() {
    return MyOrdersEntity(
      id: id ?? '',
      user: user?.toDomain() ?? MyUsers().toDomain(),
      orderItems: orderItems?.map((e) => e.toDomain()).toList() ?? [],
      totalPrice: totalPrice ?? 0,
      shippingAddress: shippingAddress?.toDomain() ?? OrderShippingAddress().toDomain(),
      paymentType: _mapPaymentType(paymentType),
      isPaid: isPaid ?? false,
      paidAt: paidAt ?? DateTime.now(),
      isDelivered: isDelivered ?? false,
      state: _mapOrderState(state),
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      v: v ?? 0,
      orderNumber: orderNumber ?? '',
    );
  }

  PaymentType _mapPaymentType(PaymentTypeModel? model) {
    switch (model) {
      case PaymentTypeModel.cash:
        return PaymentType.cash;
      default:
        return PaymentType.cash;
    }
  }

  OrderState _mapOrderState(OrderStateModel? model) {
    switch (model) {
      case OrderStateModel.completed:
        return OrderState.completed;
      case OrderStateModel.inProgress:
        return OrderState.inProgress;
      case OrderStateModel.cancelled:
        return OrderState.cancelled;
      default:
        return OrderState.inProgress;
    }
  }
}
