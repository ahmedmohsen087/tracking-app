import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditProfileUseCase {
  final ProfileRepositoryContract _repository;

  EditProfileUseCase(this._repository);

  Future<BaseResponse<EditProfileResponseEntity>> execute({
    required EditProfileRequestModel requestModel,
  }) => _repository.editProfile(requestModel: requestModel);
}
