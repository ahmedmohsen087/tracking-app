import 'package:flowery_rider_app/features/home/data/models/product.dart';
import 'package:flowery_rider_app/features/home/data/models/shipping_address.dart';
import 'package:flowery_rider_app/features/home/data/models/store.dart';
import 'package:flowery_rider_app/features/home/data/models/user.dart';
import 'package:flowery_rider_app/features/home/domain/entities/home_order_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/shipping_address_entity.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/entities/user_entity.dart';
import 'order_item.dart';
part 'home_order.g.dart';

@JsonSerializable()
class HomeOrder {
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

  HomeOrder({
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

  factory HomeOrder.fromJson(Map<String, dynamic> json) => _$HomeOrderFromJson(json);

  Map<String, dynamic> toJson() => _$HomeOrderToJson(this);
  HomeOrderEntity toDomain() {
    return HomeOrderEntity(
      id: id ?? '',
      user: user?.toDomain() ?? UserEntity(),
      orderItems: orderItems?.map((e) => e.toDomain()).toList() ?? [],
      totalPrice: totalPrice ?? 0.0,
      shippingAddress: shippingAddress?.toDomain() ?? ShippingAddressEntity(),
      paymentType: paymentType?.name ?? '',
      isPaid: isPaid ?? false,
      isDelivered: isDelivered ?? false,
      state: state?.name ?? '',
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      orderNumber: orderNumber ?? '',
      store: store?.toDomain() ?? StoreEntity(),
    );
  }
}
