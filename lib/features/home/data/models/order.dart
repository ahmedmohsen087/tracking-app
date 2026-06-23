import 'package:flowery_rider_app/features/home/data/models/product.dart';
import 'package:flowery_rider_app/features/home/data/models/shipping_address.dart';
import 'package:flowery_rider_app/features/home/data/models/store.dart';
import 'package:flowery_rider_app/features/home/data/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

import 'order_item.dart';
part 'order.g.dart';
@JsonSerializable()
class Order {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "user")
  User? user;
  @JsonKey(name: "orderItems")
  List<OrderItem>? orderItems;
  @JsonKey(name: "totalPrice")
  double? totalPrice;
  @JsonKey(name: "paymentType")
  PaymentType? paymentType;
  @JsonKey(name: "isPaid")
  bool? isPaid;
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
  @JsonKey(name: "store")
  Store? store;
  @JsonKey(name: "shippingAddress")
  ShippingAddress? shippingAddress;
  @JsonKey(name: "paidAt")
  DateTime? paidAt;

  Order({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
    this.store,
    this.shippingAddress,
    this.paidAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
