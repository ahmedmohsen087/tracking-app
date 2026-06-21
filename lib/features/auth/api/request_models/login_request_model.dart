import 'package:flowery_rider_app/core/values/api_parameters.dart';

class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({required this.email, required this.password});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      email: json[ApiParameters.email] as String,
      password: json[ApiParameters.password] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {ApiParameters.email: email, ApiParameters.password: password};
  }
}
