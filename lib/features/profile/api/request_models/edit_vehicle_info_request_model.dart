class EditVehicleInfoRequestModel {
  final String vehicleTypeId;
  final String vehicleNumber;
  final String vehicleLicenseFilePath;

  const EditVehicleInfoRequestModel({
    required this.vehicleTypeId,
    required this.vehicleNumber,
    required this.vehicleLicenseFilePath,
  });
}
