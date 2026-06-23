import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import 'package:flowery_rider_app/features/profile/data/models/get_profile_response.dart';

import '../../../../core/utils/error/error_handler.dart';
import '../../data/data_sources_contract/profile_remote_data_source_contract.dart';
import '../profile_api_client/profile_api_client.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient profileApiClient;
  ProfileRemoteDataSourceImpl(this.profileApiClient);

  @override
  Future<BaseResponse<GetProfileResponse>> getProfile() async{

    try {
      final response = profileApiClient.getProfile();
      return SuccessBaseResponse<GetProfileResponse>(data: await response);
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<GetProfileResponse>(errorMessage: message);

    }

  }
}
