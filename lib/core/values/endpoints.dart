abstract class Endpoints {
  static const String baseUrl = "https://flower.elevateegy.com/api/v1/drivers";
  static const String login = "$baseUrl/signin";
  static const String logout = "$baseUrl/logout";
  static const String forgetPassword = "$baseUrl/forgotPassword";
  static const String verifyOtp = "$baseUrl/verifyResetCode";
  static const String resetPassword = "$baseUrl/resetPassword";
}
