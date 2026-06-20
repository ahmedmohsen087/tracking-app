import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/logout_repository.dart';
import '../data_sources/logout_remote_data_source.dart';

@Injectable(as: LogoutRepository)
class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutRemoteDataSource _remoteDataSource;
  final AuthManager _authManager;

  LogoutRepositoryImpl(this._remoteDataSource, this._authManager);

  @override
  Future<BaseResponse<AuthResponse>> logout() async {
    final response = await _remoteDataSource.logout();
    switch (response) {
      case SuccessBaseResponse<AuthResponse>():
        final data = response.data;
        await _authManager.logout();
        return SuccessBaseResponse(
          data: AuthResponse(message: data.message, token: data.token),
        );
      case ErrorBaseResponse<AuthResponse>():
        return ErrorBaseResponse(
          errorMessage: response.errorMessage,
          exception: Exception(response.errorMessage),
        );
    }
  }
}
