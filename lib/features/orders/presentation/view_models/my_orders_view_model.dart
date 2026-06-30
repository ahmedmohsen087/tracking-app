import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../api/request_models/get_my_orders_request.dart';
import '../../domain/entities/my_order_element_entity.dart';
import '../../domain/entities/my_order_response_entity.dart';
import '../../domain/use_cases/get_my_orders_use_case.dart';
import 'my_order_state.dart';
import 'my_orders_events.dart';

@injectable
class MyOrdersViewModel extends Cubit<MyOrderState> {
  static const int _firstPage = 1;

  final GetMyOrdersUseCase _getMyOrdersUseCase;

  MyOrdersViewModel(this._getMyOrdersUseCase)
      : super(const MyOrderState());

  void doEvent(MyOrdersEvents event) {
    switch (event) {
      case LoadMyOrdersEvent():
        _loadMyOrders();

      case RefreshMyOrdersEvent():
        _getMyOrders(page: _firstPage, refresh: true);

      case LoadMoreMyOrdersEvent():
        _loadMoreMyOrders();

      case RejectMyOrderEvent():
        _removeOrder(event.orderId);
    }
  }

  void _loadMyOrders() {
    _getMyOrders(page: _firstPage, refresh: true);
  }

  void retryLoadMyOrders() {
    _getMyOrders(page: _firstPage, refresh: true);
  }

  void _loadMoreMyOrders() {
    if (state.getOrdersState.isLoading ||
        state.isLoadingMore ||
        !state.hasMorePages) {
      return;
    }

    _getMyOrders(page: state.currentPage + 1);
  }

  void _removeOrder(String? orderId) {
    if (orderId == null) return;

    final orders = state.getOrdersState.data ?? [];

    final updatedOrders =
    orders.where((order) => order.id != orderId).toList();

    emit(
      state.copyWith(
        getOrdersState:
        BaseState<List<MyOrderElementEntity>>.success(updatedOrders),
      ),
    );
  }

  Future<void> _getMyOrders({
    required int page,
    bool refresh = false,
  }) async {
    final isFirstPage = page == _firstPage;

    emit(
      state.copyWith(
        getOrdersState: isFirstPage
            ? BaseState<List<MyOrderElementEntity>>.loading()
            : state.getOrdersState,
        isLoadingMore: !isFirstPage,
      ),
    );

    final response = await _getMyOrdersUseCase(
      request: GetMyOrdersRequest(
        page: page,
        limit: state.limit,
      ),
    );

    switch (response) {
      case SuccessBaseResponse<MyOrderResponseEntity>():
        final currentOrders = refresh
            ? <MyOrderElementEntity>[]
            : state.getOrdersState.data ?? <MyOrderElementEntity>[];

        final orders = [
          ...currentOrders,
          ...response.data.orders,
        ];

        emit(
          state.copyWith(
            getOrdersState:
            BaseState<List<MyOrderElementEntity>>.success(orders),
            currentPage: response.data.metadata.currentPage,
            totalPages: response.data.metadata.totalPages,
            limit: response.data.metadata.limit,
            isLoadingMore: false,
          ),
        );

      case ErrorBaseResponse<MyOrderResponseEntity>():
        final currentOrders =
            state.getOrdersState.data ?? <MyOrderElementEntity>[];

        emit(
          state.copyWith(
            getOrdersState: isFirstPage
                ? BaseState<List<MyOrderElementEntity>>.error(
              response.errorMessage,
            )
                : BaseState<List<MyOrderElementEntity>>(
              data: currentOrders,
              msg: response.errorMessage,
            ),
            isLoadingMore: false,
          ),
        );
    }
  }
}