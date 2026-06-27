import 'package:equatable/equatable.dart';

import 'vehicle_type_entity.dart';

class VehicleTypesResponseEntity extends Equatable {
  final String? message;
  final List<VehicleTypeEntity> vehicles;

  const VehicleTypesResponseEntity({this.message, this.vehicles = const []});

  @override
  List<Object?> get props => [message, vehicles];
}
