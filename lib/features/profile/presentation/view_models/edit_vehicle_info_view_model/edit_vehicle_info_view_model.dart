import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_info_updated_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_types_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/edit_vehicle_info_use_case.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/get_vehicle_types_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'edit_vehicle_info_events.dart';
import 'edit_vehicle_info_state.dart';

@injectable
class EditVehicleInfoViewModel extends Cubit<EditVehicleInfoState> {
  final GetVehicleTypesUseCase _getVehicleTypesUseCase;
  final EditVehicleInfoUseCase _editVehicleInfoUseCase;

  EditVehicleInfoViewModel(
    this._getVehicleTypesUseCase,
    this._editVehicleInfoUseCase,
  ) : super(const EditVehicleInfoState());

  Future<void> doEvent(EditVehicleInfoEvents event) async {
    switch (event) {
      case GetVehicleTypesEvent():
        await _getVehicleTypes();
      case EditVehicleInfoSubmitEvent():
        await _editVehicleInfo(event);
    }
  }

  Future<void> _getVehicleTypes() async {
    emit(state.copyWith(getVehicleTypesState: BaseState.loading()));
    final response = await _getVehicleTypesUseCase.execute(page: 1, limit: 100);
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse<VehicleTypesResponseEntity>():
        emit(
          state.copyWith(
            getVehicleTypesState: BaseState.success(response.data),
          ),
        );
      case ErrorBaseResponse<VehicleTypesResponseEntity>():
        emit(
          state.copyWith(
            getVehicleTypesState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _editVehicleInfo(EditVehicleInfoSubmitEvent event) async {
    emit(state.copyWith(editVehicleInfoState: BaseState.loading()));
    final response = await _editVehicleInfoUseCase.execute(
      requestModel: event.requestModel,
    );
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse<VehicleInfoUpdatedEntity>():
        emit(
          state.copyWith(
            editVehicleInfoState: BaseState.success(response.data),
          ),
        );
      case ErrorBaseResponse<VehicleInfoUpdatedEntity>():
        emit(
          state.copyWith(
            editVehicleInfoState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }
}
