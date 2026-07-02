import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/core/values/order_status.dart';

class ActiveOrderState {
  final String status;
  final bool userConfirmed;
  final String driverName;
  final String driverPhone;
  final String userId;
  final String orderId;
  final bool isUpdating;
  final String? errorMessage;
  final BaseState<void> updateOrderState;
  final String? submittedState;

  const ActiveOrderState({
    this.status = OrderStatus.accepted,
    this.userConfirmed = false,
    this.driverName = '',
    this.driverPhone = '',
    this.userId = '',
    this.orderId = '',
    this.isUpdating = false,
    this.errorMessage,
    this.updateOrderState = const BaseState(),
    this.submittedState,
  });

  ActiveOrderState copyWith({
    String? status,
    bool? userConfirmed,
    String? driverName,
    String? driverPhone,
    String? userId,
    String? orderId,
    bool? isUpdating,
    String? errorMessage,
    BaseState<void>? updateOrderState,
    String? submittedState,
  }) {
    return ActiveOrderState(
      status: status ?? this.status,
      userConfirmed: userConfirmed ?? this.userConfirmed,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage,
      updateOrderState: updateOrderState ?? this.updateOrderState,
      submittedState: submittedState ?? this.submittedState,
    );
  }
}
