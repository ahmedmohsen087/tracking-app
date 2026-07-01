import 'package:flowery_rider_app/features/home/domain/entities/order_entity.dart';

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
  final String orderId;

  const RejectOrderEvent(this.orderId);
}

class AcceptOrderEvent extends GetHomeEvent {
  final OrderEntity order;

  const AcceptOrderEvent(this.order);
}
