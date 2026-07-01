import 'package:flowery_rider_app/features/home/data/models/shipping_address.dart';
import 'package:flowery_rider_app/features/home/domain/entities/shipping_address_entity.dart';

extension ShippingAddressModelMapper on ShippingAddress {
  ShippingAddressEntity toEntity() {
    return ShippingAddressEntity(
      street: street ?? '',
      city: city ?? '',
      phone: phone ?? '',
      lat: lat ?? '',
      long: long ?? '',
    );
  }
}
