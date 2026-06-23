abstract class ApiEndpoints {
  static const String baseUrl = "https://flower.elevateegy.com/api/v1/drivers";
  static const String login = "$baseUrl/signin";
  static const String applyDriver = "$baseUrl/apply";
  static const String logout = "$baseUrl/logout";
  static const String forgetPassword = "$baseUrl/forgotPassword";
  static const String verifyOtp = "$baseUrl/verifyResetCode";
  static const String resetPassword = "$baseUrl/resetPassword";
  static const String pendingOrders = "https://flower.elevateegy.com/api/v1/orders/pending-orders";
}
