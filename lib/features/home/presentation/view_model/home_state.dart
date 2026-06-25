import '../../../../config/base_state/base_state.dart';
import '../../domain/entities/order_entity.dart';

class HomeState {
  final BaseState<List<OrderEntity>> getOrdersState;

  const HomeState({
    this.getOrdersState = const BaseState<List<OrderEntity>>(),
  });

  HomeState copyWith({
    BaseState<List<OrderEntity>>? getOrdersState,
  }) {
    return HomeState(
      getOrdersState: getOrdersState ?? this.getOrdersState,
    );
  }
}
