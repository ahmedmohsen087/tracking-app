import 'package:equatable/equatable.dart';


class ForgetPasswordEntity extends Equatable {
  final String email;

  const ForgetPasswordEntity({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}