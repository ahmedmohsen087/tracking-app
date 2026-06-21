import 'package:equatable/equatable.dart';

class VerifyOtpEntity extends Equatable {
  final String email;
  final String otp;

  const VerifyOtpEntity({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}