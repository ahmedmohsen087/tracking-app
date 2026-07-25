sealed class ActiveOrderEvent {
  const ActiveOrderEvent();
}

class UpdateOrderStatusEvent extends ActiveOrderEvent {
  final String newStatus;

  const UpdateOrderStatusEvent(this.newStatus);
}
