sealed class GetHomeEvent {
  const GetHomeEvent();
}

class LoadHomeDataEvent extends GetHomeEvent {
  const LoadHomeDataEvent();
}

class RefreshHomeEvent extends GetHomeEvent {
  const RefreshHomeEvent();
}

class RejectOrderEvent extends GetHomeEvent {
  final String? orderId;

  const RejectOrderEvent(this.orderId);
}
