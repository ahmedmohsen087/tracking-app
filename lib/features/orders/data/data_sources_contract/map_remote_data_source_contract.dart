import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/route_entity.dart';

abstract interface class MapRemoteDataSourceContract {
  Future<RouteEntity?> getRoute({
    required LatLngPoint origin,
    required LatLngPoint destination,
  });
}
