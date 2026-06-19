import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/apply/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/apply/api/responses/apply_response.dart';

abstract interface class ApplyRemoteDataSource {
  Future<BaseResponse<ApplyResponse>> apply({
    required ApplyRequestModel requestModel,
  });
}
