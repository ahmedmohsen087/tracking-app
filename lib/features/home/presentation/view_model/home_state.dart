import '../../../../config/base_state/base_state.dart';
import '../../domain/entities/home_order_entity.dart';

class HomeState {
  final BaseState<List<HomeOrderEntity>> getOrdersState;
  final int currentPage;
  final int totalPages;
  final int limit;
  final bool isLoadingMore;

  const HomeState({
    this.getOrdersState = const BaseState<List<HomeOrderEntity>>(),
    this.currentPage = 0,
    this.totalPages = 1,
    this.limit = 10,
    this.isLoadingMore = false,
  });

  bool get hasMorePages => currentPage < totalPages;

  HomeState copyWith({
    BaseState<List<HomeOrderEntity>>? getOrdersState,
    int? currentPage,
    int? totalPages,
    int? limit,
    bool? isLoadingMore,
  }) {
    return HomeState(
      getOrdersState: getOrdersState ?? this.getOrdersState,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      limit: limit ?? this.limit,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
