import 'package:flowery_rider_app/config/base_response/base_response.dart';

abstract interface class LogoutRepository {
  Future<BaseResponse<void>> logout();
}
