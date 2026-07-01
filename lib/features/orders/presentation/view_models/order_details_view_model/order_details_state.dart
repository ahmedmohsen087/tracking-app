class OrderDetailsState {
  final String status;
  final bool userConfirmed;
  final String driverName;
  final String driverPhone;
  final String userId;
  final String orderId;
  final bool isUpdating;
  final String? errorMessage;

  const OrderDetailsState({
    this.status = 'accepted',
    this.userConfirmed = false,
    this.driverName = '',
    this.driverPhone = '',
    this.userId = '',
    this.orderId = '',
    this.isUpdating = false,
    this.errorMessage,
  });

  OrderDetailsState copyWith({
    String? status,
    bool? userConfirmed,
    String? driverName,
    String? driverPhone,
    String? userId,
    String? orderId,
    bool? isUpdating,
    String? errorMessage,
  }) {
    return OrderDetailsState(
      status: status ?? this.status,
      userConfirmed: userConfirmed ?? this.userConfirmed,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage,
    );
  }
}
