import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import '../../domain/entities/my_order_element_entity.dart';
import '../../domain/entities/my_orders_entity.dart';
import '../view_models/my_order_state.dart';
import '../view_models/my_orders_events.dart';
import '../view_models/my_orders_view_model.dart';
import '../widgets/my_order_item.dart';
import '../widgets/orders_stats_header.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  int _countByState(List<MyOrderElementEntity> orders, OrderState state) {
    return orders.where((element) => element.order.state == state).length;
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<MyOrdersViewModel, MyOrderState>(
        buildWhen: (previous, current) {
          return previous.getOrdersState != current.getOrdersState ||
              previous.isLoadingMore != current.isLoadingMore;
        },
        builder: (context, state) {
          final ordersState = state.getOrdersState;
          final orders = ordersState.data ?? [];

          if (ordersState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ordersState.msg != null && orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(ordersState.msg!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<MyOrdersViewModel>().doEvent(
                        const RefreshMyOrdersEvent(),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (orders.isEmpty) {
            return const Center(child: Text('No orders available'));
          }

          final cancelledCount = _countByState(orders, OrderState.cancelled);
          final completedCount = _countByState(orders, OrderState.completed);

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;
              final shouldLoadMore =
                  metrics.pixels >= metrics.maxScrollExtent - 200;

              if (shouldLoadMore) {
                context.read<MyOrdersViewModel>().doEvent(
                  const LoadMoreMyOrdersEvent(),
                );
              }

              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<MyOrdersViewModel>().doEvent(
                  const RefreshMyOrdersEvent(),
                );
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: orders.length + 1 + (state.isLoadingMore ? 1 : 0),
                separatorBuilder: (_, index) {
                  if (index == 0) {
                    return const SizedBox(height: 16);
                  }
                  return const SizedBox(height: 20);
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return OrdersStatsHeader(
                      cancelledCount: cancelledCount,
                      completedCount: completedCount,
                    );
                  }

                  final orderIndex = index - 1;

                  if (orderIndex == orders.length) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return MyOrderItem(orderElement: orders[orderIndex]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
