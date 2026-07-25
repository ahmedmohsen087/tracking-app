import '../../../../config/base_state/base_state.dart';
import '../../domain/entities/driver_order_element_entity.dart';

class DriverOrdersState {
  final BaseState<List<DriverOrderElementEntity>> getOrdersState;
  final int currentPage;
  final int totalPages;
  final int limit;
  final bool isLoadingMore;
  final String? orderId;
  final bool isRejected;
  final bool isRejectedLoading;
  final String? rejectedErrorMsg;

  const DriverOrdersState({
    this.getOrdersState = const BaseState<List<DriverOrderElementEntity>>(),
    this.currentPage = 0,
    this.totalPages = 1,
    this.limit = 10,
    this.isLoadingMore = false,
    this.orderId,
    this.isRejected = false,
    this.isRejectedLoading = false,
    this.rejectedErrorMsg,
  });

  bool get hasMorePages => currentPage < totalPages;

  DriverOrdersState copyWith({
    BaseState<List<DriverOrderElementEntity>>? getOrdersState,
    int? currentPage,
    int? totalPages,
    int? limit,
    bool? isLoadingMore,
    String? orderId,
    bool? isRejected,
    bool? isRejectedLoading,
    String? rejectedErrorMsg,
  }) {
    return DriverOrdersState(
      getOrdersState: getOrdersState ?? this.getOrdersState,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      limit: limit ?? this.limit,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      orderId: orderId ?? this.orderId,
      isRejected: isRejected ?? this.isRejected,
      isRejectedLoading: isRejectedLoading ?? this.isRejectedLoading,
      rejectedErrorMsg: rejectedErrorMsg ?? this.rejectedErrorMsg,
    );
  }
}