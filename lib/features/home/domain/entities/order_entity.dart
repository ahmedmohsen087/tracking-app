import 'package:equatable/equatable.dart';
import 'package:flowery_rider_app/features/home/domain/entities/shipping_address_entity.dart';
import 'package:flowery_rider_app/features/home/domain/entities/store_entity.dart';
import 'package:flowery_rider_app/features/home/domain/entities/user_entity.dart';

import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final String? id;
  final UserEntity? user;
  final List<OrderItemEntity> orderItems;
  final double? totalPrice;
  final ShippingAddressEntity? shippingAddress;
  final String? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? orderNumber;
  final StoreEntity? store;

  const OrderEntity({
    this.id,
    this.user,
    this.orderItems = const [],
    this.totalPrice,
    this.shippingAddress,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.store,
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
    isDelivered,
    state,
    createdAt,
    updatedAt,
    orderNumber,
    store,
  ];
}