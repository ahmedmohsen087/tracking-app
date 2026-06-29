import 'package:flowery_rider_app/features/profile/api/request_models/edit_vehicle_info_request_model.dart';

sealed class EditVehicleInfoEvents {}

class GetVehicleTypesEvent extends EditVehicleInfoEvents {}

class EditVehicleInfoSubmitEvent extends EditVehicleInfoEvents {
  final EditVehicleInfoRequestModel requestModel;

  EditVehicleInfoSubmitEvent({required this.requestModel});
}
