import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:flowery_rider_app/core/utils/error/error_handler.dart';
import 'package:flowery_rider_app/features/logout/api/logout_api_client/logout_api_client.dart';
import 'package:flowery_rider_app/features/logout/data/data_sources/logout_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LogoutRemoteDataSource)
class LogoutRemoteDataSourceImpl implements LogoutRemoteDataSource {
  final LogoutApiClient _logoutApiClient;

  LogoutRemoteDataSourceImpl(this._logoutApiClient);

  @override
  Future<BaseResponse<AuthResponse>> logout() async {
    try {
      final response = _logoutApiClient.logout();
      return SuccessBaseResponse<AuthResponse>(data: await response);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse<AuthResponse>(errorMessage: message);
    }
  }
}
