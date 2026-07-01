import 'package:flowery_rider_app/features/home/data/models/store.dart';
import 'package:flowery_rider_app/features/home/domain/entities/store_entity.dart';

extension StoreModelMapper on Store {
  StoreEntity toEntity() {
    return StoreEntity(
      name: name ?? '',
      image: image ?? '',
      address: address ?? '',
      phoneNumber: phoneNumber ?? '',
      latLong: latLong ?? '',
    );
  }
}
