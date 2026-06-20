import 'package:dio/dio.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/utils/error/error_handler.dart';
import 'package:flowery_rider_app/features/apply/api/apply_api_client/apply_api_client.dart';
import 'package:flowery_rider_app/features/apply/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/apply/api/responses/apply_response.dart';
import 'package:flowery_rider_app/features/apply/data/data_sources/apply_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ApplyRemoteDataSource)
class ApplyRemoteDataSourceImpl implements ApplyRemoteDataSource {
  final ApplyApiClient _apiClient;

  ApplyRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<ApplyResponse>> apply({
    required ApplyRequestModel requestModel,
  }) async {
    try {
      final formData = FormData.fromMap({
        'country': requestModel.country,
        'firstName': requestModel.firstName,
        'lastName': requestModel.lastName,
        'vehicleType': requestModel.vehicleTypeId,
        'vehicleNumber': requestModel.vehicleNumber,
        'vehicleLicense': await MultipartFile.fromFile(
          requestModel.vehicleLicensePath,
          filename: requestModel.vehicleLicensePath.split('/').last,
        ),
        'email': requestModel.email,
        'phone': requestModel.phone,
        'NID': requestModel.nid,
        'NIDImg': await MultipartFile.fromFile(
          requestModel.nidImgPath,
          filename: requestModel.nidImgPath.split('/').last,
        ),
        'password': requestModel.password,
        'rePassword': requestModel.confirmPassword,
        'gender': requestModel.gender,
      });

      final response = await _apiClient.applyAsDriver(formData);
      return SuccessBaseResponse(data: response);
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse(errorMessage: message);
    }
  }
}
