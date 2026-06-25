import 'package:flowery_rider_app/core/values/api_parameters.dart';

class ProfileRequestModel {
  final String password;
  final String newPassword;

  ProfileRequestModel({required this.newPassword, required this.password});

  factory ProfileRequestModel.fromJson(Map<String, dynamic> json) {
    return ProfileRequestModel(
      newPassword: json[ApiParameters.newPassword] as String,
      password: json[ApiParameters.password] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiParameters.newPassword: newPassword,
      ApiParameters.password: password,
    };
  }
}
