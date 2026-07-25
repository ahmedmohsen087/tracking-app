import 'package:equatable/equatable.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/driver_location_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/route_entity.dart';

enum MapPhase { loading, ready, error }

class MapState extends Equatable {
  final MapPhase phase;
  final DriverLocationEntity? driverLocation;
  final LatLngPoint? destination;
  final RouteEntity? route;
  final String? errorMessage;

  const MapState({
    this.phase = MapPhase.loading,
    this.driverLocation,
    this.destination,
    this.route,
    this.errorMessage,
  });

  MapState copyWith({
    MapPhase? phase,
    DriverLocationEntity? driverLocation,
    LatLngPoint? destination,
    RouteEntity? route,
    String? errorMessage,
  }) =>
      MapState(
        phase: phase ?? this.phase,
        driverLocation: driverLocation ?? this.driverLocation,
        destination: destination ?? this.destination,
        route: route ?? this.route,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props =>
      [phase, driverLocation, destination, route, errorMessage];
}
