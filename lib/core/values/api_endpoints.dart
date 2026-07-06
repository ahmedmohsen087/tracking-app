abstract class ApiEndpoints {
  static const String baseUrl = "https://flower.elevateegy.com/api/v1";
  static const String uploadsBaseUrl = "https://flower.elevateegy.com/uploads/";
  static const String authDrivers = "$baseUrl/drivers";
  static const String orders = "$baseUrl/orders";
  static const String login = "$authDrivers/signin";
  static const String applyDriver = "$authDrivers/apply";
  static const String logout = "$authDrivers/logout";
  static const String forgetPassword = "$authDrivers/forgotPassword";
  static const String verifyOtp = "$authDrivers/verifyResetCode";
  static const String resetPassword = "$authDrivers/resetPassword";
  static const String profile = "$authDrivers/profile-data";
  static const String changePassword = "$authDrivers/change-password";
  static const String editProfile = "$authDrivers/editProfile";
  static const String uploadPhoto = "$authDrivers/upload-photo";
  static const String getVehicleTypes = "$baseUrl/vehicles";
  static const String pendingOrders = "$orders/pending-orders";
  static const String startOrder = "$orders/start";
  static const String orderState = "$orders/state";
  static const String myOrders = "$orders/driver-orders";

  static String imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$uploadsBaseUrl$path';
  }
}
