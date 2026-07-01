import 'package:flowery_rider_app/features/home/data/models/order.dart';
import 'package:flowery_rider_app/features/home/data/models/product.dart';
import 'package:flowery_rider_app/features/home/data/models/shipping_address.dart';
import 'package:flowery_rider_app/features/home/domain/entities/order_entity.dart';
import 'package:flowery_rider_app/features/home/domain/entities/shipping_address_entity.dart';
import 'package:flowery_rider_app/features/home/domain/entities/store_entity.dart';
import 'package:flowery_rider_app/features/home/domain/entities/user_entity.dart';
import 'order_item_model_mapper.dart';
import 'shipping_address_model_mapper.dart';
import 'store_model_mapper.dart';
import 'user_model_mapper.dart';

extension OrderModelMapper on Order {
  OrderEntity toEntity() {
    return OrderEntity(
      id: id ?? '',
      user: user?.toEntity() ??
          const UserEntity(
            id: '',
            firstName: '',
            lastName: '',
            email: '',
            gender: '',
            phone: '',
            photo: '',
          ),
      orderItems: orderItems?.map((e) => e.toEntity()).toList() ?? [],
      totalPrice: totalPrice ?? 0.0,
      shippingAddress: shippingAddress?.toEntity() ??
          const ShippingAddressEntity(
            street: '',
            city: '',
            phone: '',
            lat: '',
            long: '',
          ),
      paymentType: paymentType == null
          ? ''
          : const {PaymentType.CASH: 'cash'}[paymentType!] ?? '',
      isPaid: isPaid ?? false,
      isDelivered: isDelivered ?? false,
      state: state == null
          ? ''
          : const {State.PENDING: 'pending'}[state!] ?? '',
      createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      orderNumber: orderNumber ?? '',
      store: store?.toEntity() ??
          const StoreEntity(
            name: '',
            image: '',
            address: '',
            phoneNumber: '',
            latLong: '',
          ),
    );
  }
}
