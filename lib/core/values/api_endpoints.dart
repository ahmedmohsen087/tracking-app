abstract class ApiEndpoints {
  static const String baseUrl = "https://flower.elevateegy.com/api/v1/drivers";
  static const String login = "$baseUrl/signin";
  static const String applyDriver = "$baseUrl/apply";
  static const String logout = "$baseUrl/logout";
  static const String forgetPassword = "$baseUrl/forgotPassword";
  static const String verifyOtp = "$baseUrl/verifyResetCode";
  static const String resetPassword = "$baseUrl/resetPassword";
  static const String changePassword = "$baseUrl/change-password";
  static const String editProfile = "$baseUrl/editProfile";
  static const String uploadPhoto = "$baseUrl/upload-photo";
  static const String getVehicleTypes =
      "https://flower.elevateegy.com/api/v1/vehicles";
  static const String pendingOrders = "https://flower.elevateegy.com/api/v1/orders/pending-orders";
  static const String profile = "$baseUrl/profile-data";
  static const String myOrders = "https://flower.elevateegy.com/api/v1/orders/driver-orders";

}
