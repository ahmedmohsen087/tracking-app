import 'package:equatable/equatable.dart';

class VehicleTypeEntity extends Equatable {
  final String? id;
  final String? type;
  final String? image;

  const VehicleTypeEntity({this.id, this.type, this.image});

  @override
  List<Object?> get props => [id, type, image];
}
