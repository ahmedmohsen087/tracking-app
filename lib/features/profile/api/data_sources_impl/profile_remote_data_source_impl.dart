import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/utils/error/error_handler.dart';
import 'package:flowery_rider_app/features/profile/api/profile_api_client/profile_api_client.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/data/models/profile_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_sources_contract/profile_remote_data_source_contract.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient _profileApiClient;

  ProfileRemoteDataSourceImpl(this._profileApiClient);

  @override
  Future<BaseResponse<ProfileResponseModel>> changePassword({
    required String newPassword,
    required String password,
  }) async {
    try {
      final response = await _profileApiClient.changePassword(
        ProfileRequestModel(newPassword: newPassword, password: password),
      );
      return SuccessBaseResponse<ProfileResponseModel>(data: response);
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<ProfileResponseModel>(errorMessage: message);
    }
  }
}
