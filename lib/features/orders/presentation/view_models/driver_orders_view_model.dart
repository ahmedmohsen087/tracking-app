import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../api/request_models/get_driver_orders_request.dart';
import '../../domain/entities/driver_order_element_entity.dart';
import '../../domain/entities/get_order_response_entity.dart';
import '../../domain/use_cases/get_driver_orders_use_case.dart';
import 'driver_orders_events.dart';
import 'driver_orders_state.dart';

@injectable
class DriverOrdersViewModel extends Cubit<DriverOrdersState> {
  static const int _firstPage = 1;

  final GetDriverOrdersUseCase _getDriverOrdersUseCase;

  DriverOrdersViewModel(this._getDriverOrdersUseCase)
      : super(const DriverOrdersState());

  void doEvent(DriverOrdersEvents event) {
    switch (event) {
      case LoadDriverOrdersEvent():
        _loadDriverOrders();

      case RefreshDriverOrdersEvent():
        _getDriverOrders(page: _firstPage, refresh: true);

      case LoadMoreDriverOrdersEvent():
        _loadMoreDriverOrders();

      case RejectDriverOrderEvent():
        _removeOrder(event.orderId);
    }
  }

  void _loadDriverOrders() {
    _getDriverOrders(page: _firstPage, refresh: true);
  }

  void retryLoadDriverOrders() {
    _getDriverOrders(page: _firstPage, refresh: true);
  }

  void _loadMoreDriverOrders() {
    if (state.getOrdersState.isLoading ||
        state.isLoadingMore ||
        !state.hasMorePages) {
      return;
    }

    _getDriverOrders(page: state.currentPage + 1);
  }

  void _removeOrder(String? orderId) {
    if (orderId == null) return;

    final orders = state.getOrdersState.data ?? [];

    final updatedOrders =
        orders.where((order) => order.id != orderId).toList();

    emit(
      state.copyWith(
        getOrdersState:
            BaseState<List<DriverOrderElementEntity>>.success(updatedOrders),
      ),
    );
  }

  Future<void> _getDriverOrders({
    required int page,
    bool refresh = false,
  }) async {
    final isFirstPage = page == _firstPage;

    emit(
      state.copyWith(
        getOrdersState: isFirstPage
            ? BaseState<List<DriverOrderElementEntity>>.loading()
            : state.getOrdersState,
        isLoadingMore: !isFirstPage,
      ),
    );

    final response = await _getDriverOrdersUseCase(
      request: GetDriverOrdersRequest(
        page: page,
        limit: state.limit,
      ),
    );

    switch (response) {
      case SuccessBaseResponse<GetOrderResponseEntity>():
        final currentOrders = refresh
            ? <DriverOrderElementEntity>[]
            : state.getOrdersState.data ?? <DriverOrderElementEntity>[];

        final orders = [
          ...currentOrders,
          ...response.data.orders,
        ];

        emit(
          state.copyWith(
            getOrdersState:
                BaseState<List<DriverOrderElementEntity>>.success(orders),
            currentPage: response.data.metadata.currentPage,
            totalPages: response.data.metadata.totalPages,
            limit: response.data.metadata.limit,
            isLoadingMore: false,
          ),
        );

      case ErrorBaseResponse<GetOrderResponseEntity>():
        final currentOrders =
            state.getOrdersState.data ?? <DriverOrderElementEntity>[];

        emit(
          state.copyWith(
            getOrdersState: isFirstPage
                ? BaseState<List<DriverOrderElementEntity>>.error(
                    response.errorMessage,
                  )
                : BaseState<List<DriverOrderElementEntity>>(
                    data: currentOrders,
                    msg: response.errorMessage,
                  ),
            isLoadingMore: false,
          ),
        );
    }
  }
}