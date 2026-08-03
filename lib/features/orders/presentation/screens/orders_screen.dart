import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../domain/entities/driver_order_element_entity.dart';
import '../../domain/entities/driver_orders_entity.dart';
import '../view_models/driver_orders_events.dart';
import '../view_models/driver_orders_state.dart';
import '../view_models/driver_orders_view_model.dart';
import '../widgets/driver_order_item.dart';
import '../widgets/orders_stats_header.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppStrings.myOrders,
            style: TextStyles.appBarTextStyle,
          ),
        ),
      ),
      body: const _OrdersScreenContent(),
    );
  }
}

class _OrdersScreenContent extends StatelessWidget {
  const _OrdersScreenContent();

  int _countByState(List<DriverOrderElementEntity> orders, OrderState state) {
    return orders.where((element) => element.order.state == state).length;
  }

  List<DriverOrderElementEntity> _filterCompletedAndCancelled(
    List<DriverOrderElementEntity> orders,
  ) {
    return orders.where((element) {
      return element.order.state == OrderState.completed ||
          element.order.state == OrderState.cancelled;
    }).toList();
  }

  bool _onScrollNotification(
    BuildContext context,
    ScrollNotification notification,
    DriverOrdersState state,
  ) {
    final metrics = notification.metrics;
    final shouldLoadMore = metrics.pixels >= metrics.maxScrollExtent - 200;

    if (shouldLoadMore && !state.isLoadingMore && state.hasMorePages) {
      context.read<DriverOrdersViewModel>().doEvent(
            const LoadMoreDriverOrdersEvent(),
          );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverOrdersViewModel, DriverOrdersState>(
      buildWhen: (prev, curr) {
        return prev.getOrdersState != curr.getOrdersState ||
            prev.isLoadingMore != curr.isLoadingMore;
      },
      builder: (context, state) {
        final ordersState = state.getOrdersState;
        final allOrders = ordersState.data ?? [];
        final displayOrders = _filterCompletedAndCancelled(allOrders);

        if (ordersState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ordersState.msg != null && allOrders.isEmpty) {
          return _OrdersErrorView(message: ordersState.msg!);
        }

        final cancelledCount = _countByState(allOrders, OrderState.cancelled);
        final completedCount = _countByState(allOrders, OrderState.completed);

        if (displayOrders.isEmpty) {
          return _OrdersEmptyView(
            cancelledCount: cancelledCount,
            completedCount: completedCount,
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (n) => _onScrollNotification(context, n, state),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<DriverOrdersViewModel>().doEvent(
                    const RefreshDriverOrdersEvent(),
                  );
            },
            child: _OrdersListView(
              displayOrders: displayOrders,
              cancelledCount: cancelledCount,
              completedCount: completedCount,
              isLoadingMore: state.isLoadingMore,
            ),
          ),
        );
      },
    );
  }
}

class _OrdersListView extends StatelessWidget {
  const _OrdersListView({
    required this.displayOrders,
    required this.cancelledCount,
    required this.completedCount,
    required this.isLoadingMore,
  });

  final List<DriverOrderElementEntity> displayOrders;
  final int cancelledCount;
  final int completedCount;
  final bool isLoadingMore;

  void _onOrderTap(BuildContext context, DriverOrderElementEntity item) {
    Navigator.pushNamed(
      context,
      AppRoutsName.orderDetailsScreen,
      arguments: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: displayOrders.length + 1 + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return OrdersStatsHeader(
            cancelledCount: cancelledCount,
            completedCount: completedCount,
          );
        }

        final orderIndex = index - 1;
        if (orderIndex == displayOrders.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final item = displayOrders[orderIndex];
        return GestureDetector(
          onTap: () => _onOrderTap(context, item),
          child: DriverOrderItem(orderElement: item),
        );
      },
    );
  }
}

class _OrdersErrorView extends StatelessWidget {
  const _OrdersErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<DriverOrdersViewModel>().doEvent(
                      const RefreshDriverOrdersEvent(),
                    );
              },
              child: Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersEmptyView extends StatelessWidget {
  const _OrdersEmptyView({
    required this.cancelledCount,
    required this.completedCount,
  });

  final int cancelledCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DriverOrdersViewModel>().doEvent(
              const RefreshDriverOrdersEvent(),
            );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            OrdersStatsHeader(
              cancelledCount: cancelledCount,
              completedCount: completedCount,
            ),
            const SizedBox(height: 40),
            Center(child: Text(AppStrings.noOrdersAvailable)),
          ],
        ),
      ),
    );
  }
}
