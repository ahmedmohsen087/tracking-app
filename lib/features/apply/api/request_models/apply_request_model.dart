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
}
