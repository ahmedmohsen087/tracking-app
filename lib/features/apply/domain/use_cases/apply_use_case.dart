import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/apply/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/apply/domain/entities/apply_response_entity.dart';
import 'package:flowery_rider_app/features/apply/domain/repository/apply_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ApplyUseCase {
  final ApplyRepository _repository;

  ApplyUseCase(this._repository);

  Future<BaseResponse<ApplyResponseEntity>> execute({
    required ApplyRequestModel requestModel,
  }) => _repository.apply(requestModel: requestModel);
}
