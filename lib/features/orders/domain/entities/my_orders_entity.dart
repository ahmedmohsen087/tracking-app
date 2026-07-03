import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'my_order_item_entity.dart';
import 'order_shipping_address_entity.dart';
import 'order_users_entity.dart';

enum PaymentType {
  @JsonValue('cash')
  cash,
}

enum OrderState {
  @JsonValue('completed')
  completed,

  @JsonValue('inProgress')
  inProgress,

  @JsonValue('cancelled')
  cancelled,
}

class MyOrdersEntity extends Equatable {
  final String id;
  final OrderUsersEntity user;
  final List<MyOrderItemEntity> orderItems;
  final double totalPrice;
  final OrderShippingAddressEntity shippingAddress;
  final PaymentType paymentType;
  final bool isPaid;
  final DateTime paidAt;
  final bool isDelivered;
  final OrderState state;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String orderNumber;

  const MyOrdersEntity({
    required this.id,
    required this.user,
    required this.orderItems,
    required this.totalPrice,
    required this.shippingAddress,
    required this.paymentType,
    required this.isPaid,
    required this.paidAt,
    required this.isDelivered,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.orderNumber,
  });

  @override
  List<Object?> get props => [
    id,
    user,
    orderItems,
    totalPrice,
    shippingAddress,
    paymentType,
    isPaid,
    paidAt,
    isDelivered,
    state,
    createdAt,
    updatedAt,
    v,
    orderNumber,
  ];
}