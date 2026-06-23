import 'package:flowery_rider_app/config/base_response/base_response.dart';

import '../../../auth/domain/entities/driver_entity.dart';

abstract interface class ProfileRepositoryContract {

  Future<BaseResponse<DriverEntity>> getProfile();
}
