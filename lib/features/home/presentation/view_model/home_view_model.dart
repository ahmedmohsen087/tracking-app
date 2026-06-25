import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/use_cases/get_orders_use_case.dart';
import 'home_events.dart';
import 'home_state.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final GetOrdersUseCase _getOrdersUseCase;

  HomeViewModel(this._getOrdersUseCase) : super(const HomeState());

  void doEvent(GetHomeEvent event) {
    switch (event) {
      case LoadHomeDataEvent():
        _loadHomeData();

      case RefreshHomeEvent():
        _getOrders();

      case RejectOrderEvent():
        _removeOrder(event.orderId);
    }
  }

  void _loadHomeData() {
    _getOrders();
  }

  void retryLoadHomeData() {
    _getOrders();
  }

  void _removeOrder(String? orderId) {
    if (orderId == null) return;

    final orders = state.getOrdersState.data ?? [];
    final updatedOrders = orders.where((order) => order.id != orderId).toList();

    emit(
      state.copyWith(
        getOrdersState: BaseState<List<OrderEntity>>.success(updatedOrders),
      ),
    );
  }

  Future<void> _getOrders() async {
    emit(
      state.copyWith(getOrdersState: BaseState<List<OrderEntity>>.loading()),
    );

    final response = await _getOrdersUseCase();

    switch (response) {
      case SuccessBaseResponse<List<OrderEntity>>():
        emit(
          state.copyWith(
            getOrdersState: BaseState<List<OrderEntity>>.success(response.data),
          ),
        );

      case ErrorBaseResponse<List<OrderEntity>>():
        emit(
          state.copyWith(
            getOrdersState: BaseState<List<OrderEntity>>.error(
              response.errorMessage,
            ),
          ),
        );
    }
  }
}
