import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';

abstract interface class LoginRemoteDataSource {
  Future<BaseResponse<AuthResponse>> login({
    required String email,
    required String password,
  });
}
