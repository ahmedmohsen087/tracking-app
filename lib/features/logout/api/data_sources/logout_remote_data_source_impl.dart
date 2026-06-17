import 'package:flowery_rider_app/features/logout/api/logout_api_client/logout_api_client.dart';
import 'package:flowery_rider_app/features/logout/data/data_sources/logout_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LogoutRemoteDataSource)
class LogoutRemoteDataSourceImpl implements LogoutRemoteDataSource {
  final LogoutApiClient _logoutApiClient;

  LogoutRemoteDataSourceImpl(this._logoutApiClient);

  @override
  Future<void> logout() {
    return _logoutApiClient.logout();
  }
}
