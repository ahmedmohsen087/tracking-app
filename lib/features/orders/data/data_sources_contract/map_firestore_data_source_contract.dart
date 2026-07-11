import 'package:flowery_rider_app/features/orders/domain/entities/driver_location_entity.dart';

abstract interface class MapFirestoreDataSourceContract {
  Stream<DriverLocationEntity> watchDriverLocation(String orderId);
}
