import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/apply/domain/entities/apply_response_entity.dart';
import 'package:flowery_rider_app/features/apply/domain/use_cases/apply_use_case.dart';
import 'package:flowery_rider_app/features/apply/presentation/view_model/apply_events.dart';
import 'package:flowery_rider_app/features/apply/presentation/view_model/apply_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ApplyViewModel extends Cubit<ApplyState> {
  final ApplyUseCase _applyUseCase;
  final AuthManager _authManager;

  ApplyViewModel(this._applyUseCase, this._authManager)
    : super(const ApplyState());

  Future<void> doEvent(ApplyEvents event) async {
    switch (event) {
      case SubmitApplyEvent():
        await _submitApply(event);
    }
  }

  Future<void> _submitApply(SubmitApplyEvent event) async {
    emit(state.copyWith(applyState: BaseState.loading()));

    final response = await _applyUseCase.execute(
      requestModel: event.requestModel,
    );

    switch (response) {
      case SuccessBaseResponse<ApplyResponseEntity>():
        final token = response.data.token;
        if (token != null && token.isNotEmpty) {
          await _authManager.setAuthData(token: token , );
        }
        emit(state.copyWith(applyState: BaseState.success(response.data)));

      case ErrorBaseResponse<ApplyResponseEntity>():
        emit(
          state.copyWith(applyState: BaseState.error(response.errorMessage)),
        );
    }
  }
}
