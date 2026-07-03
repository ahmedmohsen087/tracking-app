import 'package:flowery_rider_app/features/auth/domain/entities/driver_entity.dart';
import 'package:flowery_rider_app/features/auth/data/models/driver_model.dart';

extension DriverModelMapper on Driver {
  DriverEntity toEntity() {
    return DriverEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      photo: photo,
      gender: gender,
      country: country,
      role: role,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
      nid: nid,
      nidImg: nidImg,
      createdAt: createdAt,
    );
  }
}