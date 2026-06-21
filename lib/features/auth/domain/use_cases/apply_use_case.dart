import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ApplyUseCase {
  final AuthRepositoryContract _repository;

  ApplyUseCase(this._repository);

  Future<BaseResponse<AuthResponseEntity>> execute({
    required ApplyRequestModel requestModel,
  }) => _repository.apply(requestModel: requestModel);
}
