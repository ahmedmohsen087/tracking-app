import 'package:flowery_rider_app/config/base_response/base_response.dart';

import '../entities/profile_driver_entity.dart';

abstract interface class ProfileRepositoryContract {

  Future<BaseResponse<ProfileDriverEntity>> getProfile();
}
