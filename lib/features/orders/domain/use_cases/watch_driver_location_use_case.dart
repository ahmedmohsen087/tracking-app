import 'package:flowery_rider_app/features/orders/domain/entities/driver_location_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/repository_contract/map_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchDriverLocationUseCase {
  final MapRepositoryContract _repo;

  WatchDriverLocationUseCase(this._repo);

  Stream<DriverLocationEntity> call(String orderId) =>
      _repo.watchDriverLocation(orderId);
}
