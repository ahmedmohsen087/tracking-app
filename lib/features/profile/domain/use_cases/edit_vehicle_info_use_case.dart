import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_vehicle_info_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_info_updated_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditVehicleInfoUseCase {
  final ProfileRepositoryContract _repository;

  EditVehicleInfoUseCase(this._repository);

  Future<BaseResponse<VehicleInfoUpdatedEntity>> execute({
    required EditVehicleInfoRequestModel requestModel,
  }) async {
    return await _repository.editVehicleInfo(requestModel: requestModel);
  }
}
