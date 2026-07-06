import 'package:equatable/equatable.dart';

class StartOrderEntity extends Equatable {
  final String orderId;
  final String userId;

  const StartOrderEntity({
    required this.orderId,
    required this.userId,
  });

  @override
  List<Object?> get props => [orderId, userId];
}
