import '../../../../config/base_state/base_state.dart';
import '../../domain/entities/order_entity.dart';

class HomeState {
  final String? acceptingOrderId;
  final BaseState<List<OrderEntity>> getOrdersState;
  final int currentPage;
  final int totalPages;
  final int limit;
  final bool isLoadingMore;
  final BaseState<OrderEntity> acceptOrderState;

  const HomeState({
    this.acceptingOrderId,
    this.getOrdersState = const BaseState<List<OrderEntity>>(),
    this.currentPage = 0,
    this.totalPages = 1,
    this.limit = 10,
    this.isLoadingMore = false,
    this.acceptOrderState = const BaseState<OrderEntity>(),
  });

  bool get hasMorePages => currentPage < totalPages;

  HomeState copyWith({
    String? acceptingOrderId,
    bool clearAcceptingOrder = false,
    BaseState<List<OrderEntity>>? getOrdersState,
    int? currentPage,
    int? totalPages,
    int? limit,
    bool? isLoadingMore,
    BaseState<OrderEntity>? acceptOrderState,
  }) {
    return HomeState(
      acceptingOrderId: clearAcceptingOrder
          ? null
          : acceptingOrderId ?? this.acceptingOrderId,
      getOrdersState: getOrdersState ?? this.getOrdersState,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      limit: limit ?? this.limit,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      acceptOrderState: acceptOrderState ?? this.acceptOrderState,
    );
  }
}
