import 'package:dio/dio.dart';
import 'package:flowery_rider_app/core/values/api_parameters.dart';

class ApplyRequestModel {
  final String country;
  final String firstName;
  final String lastName;
  final String vehicleTypeId;
  final String vehicleNumber;
  final String vehicleLicensePath;
  final String email;
  final String phone;
  final String nid;
  final String nidImgPath;
  final String password;
  final String confirmPassword;
  final String gender;

  const ApplyRequestModel({
    required this.country,
    required this.firstName,
    required this.lastName,
    required this.vehicleTypeId,
    required this.vehicleNumber,
    required this.vehicleLicensePath,
    required this.email,
    required this.phone,
    required this.nid,
    required this.nidImgPath,
    required this.password,
    required this.confirmPassword,
    required this.gender,
  });
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      ApiParameters.country: country,
      ApiParameters.firstName: firstName,
      ApiParameters.lastName: lastName,
      ApiParameters.vehicleType: vehicleTypeId,
      ApiParameters.vehicleNumber: vehicleNumber,
      ApiParameters.vehicleLicense: await MultipartFile.fromFile(
        vehicleLicensePath,
        filename: vehicleLicensePath.split('/').last,
      ),
      ApiParameters.email: email,
      ApiParameters.phone: phone,
      ApiParameters.nid: nid,
      ApiParameters.nidImg: await MultipartFile.fromFile(
        nidImgPath,
        filename: nidImgPath.split('/').last,
      ),
      ApiParameters.password: password,
      ApiParameters.rePassword: confirmPassword,
      ApiParameters.gender: gender,
    });
  }
}
