
sealed class AuthState {}

class AuthInitial extends AuthState {}

// Forget Password States
class ForgetPasswordLoading extends AuthState {}
class ForgetPasswordSuccess extends AuthState {}
class ForgetPasswordError extends AuthState {
  final String message;
  ForgetPasswordError(this.message);
}

// Verify OTP States
class VerifyOtpLoading extends AuthState {}
class VerifyOtpSuccess extends AuthState {}
class VerifyOtpError extends AuthState {
  final String message;
  VerifyOtpError(this.message);
}

// Reset Password States
class ResetPasswordLoading extends AuthState {}
class ResetPasswordSuccess extends AuthState {}
class ResetPasswordError extends AuthState {
  final String message;
  ResetPasswordError(this.message);
}