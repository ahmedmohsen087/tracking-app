import 'package:dio/dio.dart';
import 'package:flowery_rider_app/features/orders/data/data_sources_contract/map_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/orders/data/models/osrm_route_response.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/route_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MapRemoteDataSourceContract)
class MapRemoteDataSourceImpl implements MapRemoteDataSourceContract {
  final Dio _dio;

  MapRemoteDataSourceImpl(this._dio);

  @override
  Future<RouteEntity?> getRoute({
    required LatLngPoint origin,
    required LatLngPoint destination,
  }) async {
    try {
      final url =
          'https://router.project-osrm.org/route/v1/driving/${origin.lng},${origin.lat};${destination.lng},${destination.lat}?overview=full&geometries=geojson';
      final response = await _dio.get<Map<String, dynamic>>(url);
      final data = response.data;
      if (data == null) return null;
      final osrm = OsrmRouteResponse.fromJson(data);
      final routes = osrm.routes;
      if (routes == null || routes.isEmpty) return null;
      final route = routes.first;
      final coords = route.geometry?.coordinates ?? [];
      return RouteEntity(
        waypoints:
            coords.map((c) => LatLngPoint(lat: c[1], lng: c[0])).toList(),
        distanceMeters: route.distance ?? 0,
        durationSeconds: route.duration ?? 0,
      );
    } catch (_) {
      return null;
    }
  }
}
