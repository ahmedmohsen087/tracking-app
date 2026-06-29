import 'package:equatable/equatable.dart';

import 'home_order_entity.dart';

class OrdersPageEntity extends Equatable {
  final List<HomeOrderEntity> orders;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;

  const OrdersPageEntity({
    this.orders = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.limit = 10,
  });

  bool get hasMorePages => currentPage < totalPages;

  @override
  List<Object?> get props => [
    orders,
    currentPage,
    totalPages,
    totalItems,
    limit,
  ];
}
