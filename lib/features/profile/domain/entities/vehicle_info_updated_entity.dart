import 'package:equatable/equatable.dart';

class VehicleInfoUpdatedEntity extends Equatable {
  final String vehicleTypeId;
  final String vehicleNumber;
  final String vehicleLicenseFileName;

  const VehicleInfoUpdatedEntity({
    required this.vehicleTypeId,
    required this.vehicleNumber,
    required this.vehicleLicenseFileName,
  });

  @override
  List<Object?> get props => [
    vehicleTypeId,
    vehicleNumber,
    vehicleLicenseFileName,
  ];
}
