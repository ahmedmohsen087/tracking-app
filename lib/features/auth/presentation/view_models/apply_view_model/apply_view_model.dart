import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/apply_view_model/apply_events.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/apply_view_model/apply_state.dart';
import 'package:flowery_rider_app/features/auth/domain/use_cases/apply_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionResult { granted, denied, permanentlyDenied }

@injectable
class ApplyViewModel extends Cubit<ApplyState> {
  final ApplyUseCase _applyUseCase;

  ApplyViewModel(this._applyUseCase) : super(const ApplyState());

  Future<void> doEvent(ApplyEvents event) async {
    switch (event) {
      case SubmitApplyEvent():
        await _submitApply(event);
    }
  }

  Future<void> _submitApply(SubmitApplyEvent event) async {
    emit(state.copyWith(applyState: BaseState.loading()));

    final response = await _applyUseCase.execute(
      applyRequestModel: event.requestModel,
    );

    switch (response) {
      case SuccessBaseResponse<AuthResponseEntity>():
        emit(state.copyWith(applyState: BaseState.success(response.data)));

      case ErrorBaseResponse<AuthResponseEntity>():
        emit(
          state.copyWith(applyState: BaseState.error(response.errorMessage)),
        );
    }
  }

  Future<PermissionResult> checkPermissions() async {
    var status = await Permission.photos.request();
    if (status.isGranted || status.isLimited) return PermissionResult.granted;
    if (status.isPermanentlyDenied) return PermissionResult.permanentlyDenied;

    status = await Permission.storage.request();
    if (status.isGranted) return PermissionResult.granted;
    if (status.isPermanentlyDenied) return PermissionResult.permanentlyDenied;

    return PermissionResult.denied;