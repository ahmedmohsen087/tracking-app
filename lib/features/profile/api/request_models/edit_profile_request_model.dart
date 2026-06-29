import 'package:flowery_rider_app/core/values/api_parameters.dart';

class EditProfileRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const EditProfileRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiParameters.firstName: firstName,
      ApiParameters.lastName: lastName,
      ApiParameters.email: email,
      ApiParameters.phone: phone,
    };
  }
}
