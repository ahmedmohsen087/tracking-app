sealed class MyOrdersEvents {
  const MyOrdersEvents();
}

class LoadMyOrdersEvent extends MyOrdersEvents {
  const LoadMyOrdersEvent();
}

class RefreshMyOrdersEvent extends MyOrdersEvents {
  const RefreshMyOrdersEvent();
}

class LoadMoreMyOrdersEvent extends MyOrdersEvents {
  const LoadMoreMyOrdersEvent();
}

class RejectMyOrderEvent extends MyOrdersEvents {
  final String? orderId;
  const RejectMyOrderEvent(this.orderId);
}
