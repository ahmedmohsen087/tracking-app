import 'package:flowery_rider_app/core/values/api_parameters.dart';

class ProfileRequestModel {
  final String password;
  final String newPassword;

  ProfileRequestModel({required this.newPassword, required this.password});

  Map<String, dynamic> toJson() {
    return {
      ApiParameters.newPassword: newPassword,
      ApiParameters.password: password,
    };
  }
}
