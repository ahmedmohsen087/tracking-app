import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/change_password_usecase.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_events.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordViewModel extends Cubit<ChangePasswordState> {
  ChangePasswordViewModel(this._changePasswordUseCase, this._authManager)
    : super(const ChangePasswordState());

  final ChangePasswordUseCase _changePasswordUseCase;
  final AuthManager _authManager;

  void doEvent(ChangePasswordEvent event) {
    switch (event) {
      case ChangePasswordRequestEvent():
        _changePassword(
          password: event.password,
          newPassword: event.newPassword,
        );
        break;
      case EnableAutoValidateEvent():
        emit(state.copyWith(autoValidate: true));
        break;
    }
  }

  Future<void> _changePassword({
    required String password,
    required String newPassword,
  }) async {
    emit(state.copyWith(changePasswordState: BaseState.loading()));

    final requestModel = ProfileRequestModel(
      password: password,
      newPassword: newPassword,
    );

    final response = await _changePasswordUseCase.execute(
      requestModel: requestModel,
    );

    switch (response) {
      case SuccessBaseResponse<ProfileResponseEntity>():
        final newToken = response.data.token;
        if (newToken != null && newToken.isNotEmpty) {
          await _authManager.setAuthData(token: newToken);
        }

        emit(
          state.copyWith(changePasswordState: BaseState.success(response.data)),
        );
        break;

      case ErrorBaseResponse<ProfileResponseEntity>():
        emit(
          state.copyWith(
            changePasswordState: BaseState.error(response.errorMessage),
          ),
        );
        break;
    }
  }
}
