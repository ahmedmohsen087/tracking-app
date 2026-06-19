import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/apply/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/apply/domain/entities/apply_response_entity.dart';

abstract interface class ApplyRepository {
  Future<BaseResponse<ApplyResponseEntity>> apply({
    required ApplyRequestModel requestModel,
  });
}
