import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/login_request_model.dart';
import 'package:flowery_rider_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'login_events.dart';
import 'login_state.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(this._loginUseCase, this._authManager)
    : super(const LoginState());
  final LoginUseCase _loginUseCase;
  final AuthManager _authManager;

  void doEvent(LoginEvents event) {
    switch (event) {
      case LoginRequestEvent():
        _loginUser(loginRequestModel: event.requestModel);
        break;
      case RememberMeEvent():
        _rememberMe(event.rememberMe);
        break;
    }
  }

  Future<void> _loginUser({
    required LoginRequestModel loginRequestModel,
  }) async {
    emit(state.copyWith(loginState: BaseState.loading()));
    final response = await _loginUseCase.execute(
      loginRequestModel: loginRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<AuthResponseEntity>():
        emit(state.copyWith(loginState: BaseState.success(response.data)));
        break;
      case ErrorBaseResponse<AuthResponseEntity>():
        emit(
          state.copyWith(loginState: BaseState.error(response.errorMessage)),
        );
        break;
    }
  }

  void _rememberMe(bool rememberMe) {
    _authManager.setRememberMe(rememberMe);
  }
}
