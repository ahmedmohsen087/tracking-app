import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/route_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/repository_contract/map_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetRouteUseCase {
  final MapRepositoryContract _repo;

  GetRouteUseCase(this._repo);

  Future<RouteEntity?> call({
    required LatLngPoint origin,
    required LatLngPoint destination,
  }) =>
      _repo.getRoute(origin: origin, destination: destination);
}
