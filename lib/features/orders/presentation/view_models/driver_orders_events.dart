sealed class DriverOrdersEvents {
  const DriverOrdersEvents();
}

class LoadDriverOrdersEvent extends DriverOrdersEvents {
  const LoadDriverOrdersEvent();
}

class RefreshDriverOrdersEvent extends DriverOrdersEvents {
  const RefreshDriverOrdersEvent();
}

class LoadMoreDriverOrdersEvent extends DriverOrdersEvents {
  const LoadMoreDriverOrdersEvent();
}

class RejectDriverOrderEvent extends DriverOrdersEvents {
  final String? orderId;
  const RejectDriverOrderEvent(this.orderId);
}
