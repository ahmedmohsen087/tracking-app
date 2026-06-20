import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/logout_repository.dart';
import '../data_sources/logout_remote_data_source.dart';

@Injectable(as: LogoutRepository)
class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutRemoteDataSource _remoteDataSource;
  final AuthManager _authManager;

  LogoutRepositoryImpl(this._remoteDataSource, this._authManager);

  @override
  Future<BaseResponse<void>> logout() async {
    final response = await _remoteDataSource.logout();
    try {
      await _remoteDataSource.logout();
      await _authManager.logout();

      return SuccessBaseResponse(data: null);
    } catch (e) {
      // TODO: Handle logout error message
      return ErrorBaseResponse(errorMessage: response.errorMessage);
    }
  }
}
