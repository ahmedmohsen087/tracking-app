import 'package:flowery_rider_app/features/orders/data/data_sources_contract/map_firestore_data_source_contract.dart';
import 'package:flowery_rider_app/features/orders/data/data_sources_contract/map_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/driver_location_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/route_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/repository_contract/map_repository_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MapRepositoryContract)
class MapRepositoryImpl implements MapRepositoryContract {
  final MapFirestoreDataSourceContract _firestoreDs;
  final MapRemoteDataSourceContract _remoteDs;

  MapRepositoryImpl(this._firestoreDs, this._remoteDs);

  @override
  Stream<DriverLocationEntity> watchDriverLocation(String orderId) =>
      _firestoreDs.watchDriverLocation(orderId);

  @override
  Future<RouteEntity?> getRoute({
    required LatLngPoint origin,
    required LatLngPoint destination,
  }) =>
      _remoteDs.getRoute(origin: origin, destination: destination);
}
