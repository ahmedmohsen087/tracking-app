import 'package:equatable/equatable.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../domain/entities/order_entity.dart';

class HomeState extends Equatable {
  final BaseState<OrderEntity> getHomeState;

  const HomeState({this.getHomeState = const BaseState()});

 HomeState copyWith({
    BaseState<OrderEntity>? getHomeState,
  }) {
    return HomeState(
      getHomeState: getHomeState ?? this.getHomeState,
    );
 }

  @override
  List<Object?> get props => [getHomeState];
}
