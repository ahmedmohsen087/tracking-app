import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_types_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetVehicleTypesUseCase {
  final ProfileRepositoryContract _repository;

  GetVehicleTypesUseCase(this._repository);

  Future<BaseResponse<VehicleTypesResponseEntity>> execute({
    required int page,
    required int limit,
  }) => _repository.getVehicleTypes(page: page, limit: limit);
}
