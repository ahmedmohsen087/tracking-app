import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';

abstract interface class LogoutRemoteDataSource {
  Future<BaseResponse<AuthResponse>> logout();
}
