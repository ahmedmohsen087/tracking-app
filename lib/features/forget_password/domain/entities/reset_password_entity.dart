import 'package:equatable/equatable.dart';

class ResetPasswordEntity  extends Equatable{
  final String email;
  final String newPassword;

  const ResetPasswordEntity({
    required this.email,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, newPassword];
}