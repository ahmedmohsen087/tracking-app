import 'package:flowery_rider_app/features/orders/domain/entities/driver_location_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/route_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';

abstract interface class MapRepositoryContract {
  Stream<DriverLocationEntity> watchDriverLocation(String orderId);

  Future<RouteEntity?> getRoute({
    required LatLngPoint origin,
    required LatLngPoint destination,
  });
}
