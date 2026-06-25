import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepositoryContract _profileRepositoryConract;

  ChangePasswordUseCase(this._profileRepositoryConract);

  Future<BaseResponse<ProfileResponseEntity>> execute({
    required ProfileRequestModel requestModel,
  }) {
    return _profileRepositoryConract.changePassword(
      newPassword: requestModel.newPassword,
      password: requestModel.password,
    );
  }
}
