import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:flowery_rider_app/features/login/api/request_models/login_request_model.dart';
import 'package:injectable/injectable.dart';
import '../../data/data_sources/login_remote_data_source.dart';
import '../login_api_client/login_api_client.dart';

@Injectable(as: LoginRemoteDataSource)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final LoginApiClient _loginApiClient;

  LoginRemoteDataSourceImpl(this._loginApiClient);

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return _loginApiClient.login(
      LoginRequestModel(email: email, password: password, rememberMe: true),
    );
  }
}
