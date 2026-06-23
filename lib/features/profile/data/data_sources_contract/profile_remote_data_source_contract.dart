import 'package:flowery_rider_app/features/profile/data/models/get_profile_response.dart';

import '../../../../config/base_response/base_response.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<BaseResponse<GetProfileResponse>> getProfile();
}
