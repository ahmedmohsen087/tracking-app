import 'package:json_annotation/json_annotation.dart';

import '../../../home/data/models/product.dart';
import '../../domain/entities/my_orders_entity.dart';
import 'my_order_item.dart';
import 'my_users.dart';
import 'order_shipping_address.dart';
part 'my_orders.g.dart';
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
  PaymentType? paymentType;
  @JsonKey(name: "isPaid")
  bool? isPaid;
  @JsonKey(name: "paidAt")
  DateTime? paidAt;
  @JsonKey(name: "isDelivered")
  bool? isDelivered;
  @JsonKey(name: "state")
  State? state;
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
  MyOrdersEntity toDomain (){
    return MyOrdersEntity(
      id: id ?? '',
      user: user ?? MyUsers(),
        orderItems: orderItems ?? [],
      totalPrice: totalPrice ?? 0,
      shippingAddress: shippingAddress ?? OrderShippingAddress(),
        paymentType: paymentType ?? PaymentType.CASH,
      isPaid: isPaid ?? false,
      paidAt: paidAt ?? DateTime.now(),
      isDelivered: isDelivered ?? false,
      state: state ?? State.COMPLETED,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      v: v ?? 0,
      orderNumber: orderNumber ?? '',
    );
  }

  }
