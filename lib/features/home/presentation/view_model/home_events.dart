sealed class GetHomeEvent {
  const GetHomeEvent();
}

class LoadHomeDataEvent extends GetHomeEvent {
  const LoadHomeDataEvent();
}

class RefreshHomeEvent extends GetHomeEvent {
  const RefreshHomeEvent();
}

class LoadMoreOrdersEvent extends GetHomeEvent {
  const LoadMoreOrdersEvent();
}

class RejectOrderEvent extends GetHomeEvent {
  final String? orderId;

  const RejectOrderEvent(this.orderId);
}
