import 'package:equatable/equatable.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_info_updated_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_types_response_entity.dart';

class EditVehicleInfoState extends Equatable {
  final BaseState<VehicleTypesResponseEntity> getVehicleTypesState;
  final BaseState<VehicleInfoUpdatedEntity> editVehicleInfoState;

  const EditVehicleInfoState({
    this.getVehicleTypesState = const BaseState(),
    this.editVehicleInfoState = const BaseState(),
  });

  EditVehicleInfoState copyWith({
    BaseState<VehicleTypesResponseEntity>? getVehicleTypesState,
    BaseState<VehicleInfoUpdatedEntity>? editVehicleInfoState,
  }) {
    return EditVehicleInfoState(
      getVehicleTypesState: getVehicleTypesState ?? this.getVehicleTypesState,
      editVehicleInfoState: editVehicleInfoState ?? this.editVehicleInfoState,
    );
  }

  @override
  List<Object?> get props => [getVehicleTypesState, editVehicleInfoState];
}
