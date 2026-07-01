sealed class OrderDetailsEvent {
  const OrderDetailsEvent();
}

class UpdateOrderStatusEvent extends OrderDetailsEvent {
  final String newStatus;

  const UpdateOrderStatusEvent(this.newStatus);
}
