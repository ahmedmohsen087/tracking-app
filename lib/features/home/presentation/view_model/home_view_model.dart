import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';

import '../../api/request_models/get_orders_request.dart';
import '../../domain/entities/home_order_entity.dart';
import '../../domain/entities/orders_page_entity.dart';
import '../../domain/use_cases/get_orders_use_case.dart';
import 'home_events.dart';
import 'home_state.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  static const int _firstPage = 1;

  final GetOrdersUseCase _getOrdersUseCase;

  HomeViewModel(this._getOrdersUseCase) : super(const HomeState());

  void doEvent(GetHomeEvent event) {
    switch (event) {
      case LoadHomeDataEvent():
        _loadHomeData();

      case RefreshHomeEvent():
        _getOrders(page: _firstPage, refresh: true);

      case LoadMoreOrdersEvent():
        _loadMoreOrders();

      case RejectOrderEvent():
        _removeOrder(event.orderId);
    }
  }

  void _loadHomeData() {
    _getOrders(page: _firstPage, refresh: true);
  }

  void retryLoadHomeData() {
    _getOrders(page: _firstPage, refresh: true);
  }

  void _loadMoreOrders() {
    if (state.getOrdersState.isLoading ||
        state.isLoadingMore ||
        !state.hasMorePages) {
      return;
    }

    _getOrders(page: state.currentPage + 1);
  }

  void _removeOrder(String? orderId) {
    if (orderId == null) return;

    final orders = state.getOrdersState.data ?? [];
    final updatedOrders = orders.where((order) => order.id != orderId).toList();

    emit(
      state.copyWith(
        getOrdersState: BaseState<List<HomeOrderEntity>>.success(updatedOrders),
      ),
    );
  }

  Future<void> _getOrders({required int page, bool refresh = false}) async {
    final isFirstPage = page == _firstPage;

    emit(
      state.copyWith(
        getOrdersState: isFirstPage
            ? BaseState<List<HomeOrderEntity>>.loading()
            : state.getOrdersState,
        isLoadingMore: !isFirstPage,
      ),
    );

    final response = await _getOrdersUseCase(
      request: GetOrdersRequest(
        page: page,
        limit: state.limit,
      ),
    );

    switch (response) {
      case SuccessBaseResponse<OrdersPageEntity>():
        final currentOrders = refresh
            ? <HomeOrderEntity>[]
            : state.getOrdersState.data ?? <HomeOrderEntity>[];
        final orders = [...currentOrders, ...response.data.orders];

        emit(
          state.copyWith(
            getOrdersState: BaseState<List<HomeOrderEntity>>.success(orders),
            currentPage: response.data.currentPage,
            totalPages: response.data.totalPages,
            limit: response.data.limit,
            isLoadingMore: false,
          ),
        );

      case ErrorBaseResponse<OrdersPageEntity>():
        final currentOrders = state.getOrdersState.data ?? <HomeOrderEntity>[];

        emit(
          state.copyWith(
            getOrdersState: isFirstPage
                ? BaseState<List<HomeOrderEntity>>.error(response.errorMessage)
                : BaseState<List<HomeOrderEntity>>(
                    data: currentOrders,
                    msg: response.errorMessage,
                  ),
            isLoadingMore: false,
          ),
        );
    }
  }
}
