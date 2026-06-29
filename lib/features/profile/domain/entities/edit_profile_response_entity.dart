import 'package:equatable/equatable.dart';

import 'driver_profile_entity.dart';

class EditProfileResponseEntity extends Equatable {
  final String? message;
  final DriverProfileEntity? driver;

  const EditProfileResponseEntity({this.message, this.driver});

  @override
  List<Object?> get props => [message, driver];

  EditProfileResponseEntity copyWith({
    String? message,
    DriverProfileEntity? driver,
  }) {
    return EditProfileResponseEntity(
      message: message ?? this.message,
      driver: driver ?? this.driver,
    );
  }
}
