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

  int _countByState(List<DriverOrderElementEntity> orders, OrderState state) {
    return orders.where((element) => element.order.state == state).length;
  }

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
      body: BlocBuilder<DriverOrdersViewModel, DriverOrdersState>(
        buildWhen: (previous, current) {
          return previous.getOrdersState != current.getOrdersState ||
              previous.isLoadingMore != current.isLoadingMore;
        },
        builder: (context, state) {
          final ordersState = state.getOrdersState;
          final allOrders = ordersState.data ?? [];

          // Filter out inProgress orders (show completed & cancelled only)
          final displayOrders = allOrders.where((element) {
            return element.order.state == OrderState.completed ||
                element.order.state == OrderState.cancelled;
          }).toList();

          if (ordersState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ordersState.msg != null && allOrders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(ordersState.msg!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<DriverOrdersViewModel>().doEvent(
                        const RefreshDriverOrdersEvent(),
                      ),
                      child: Text(AppStrings.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          final cancelledCount = _countByState(allOrders, OrderState.cancelled);
          final completedCount = _countByState(allOrders, OrderState.completed);

          if (displayOrders.isEmpty) {
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

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;
              final shouldLoadMore =
                  metrics.pixels >= metrics.maxScrollExtent - 200;

              if (shouldLoadMore &&
                  !state.isLoadingMore &&
                  state.hasMorePages) {
                context.read<DriverOrdersViewModel>().doEvent(
                  const LoadMoreDriverOrdersEvent(),
                );
              }

              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<DriverOrdersViewModel>().doEvent(
                  const RefreshDriverOrdersEvent(),
                );
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount:
                    displayOrders.length + 1 + (state.isLoadingMore ? 1 : 0),
                separatorBuilder: (_, index) {
                  if (index == 0) {
                    return const SizedBox(height: 16);
                  }
                  return const SizedBox(height: 16);
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return OrdersStatsHeader(
                      cancelledCount: cancelledCount,
                      completedCount: completedCount,
                    );
                  }

                  final orderIndex = index - 1;

                  if (orderIndex == displayOrders.length) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final item = displayOrders[orderIndex];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutsName.orderDetailsScreen,
                        arguments: item,
                      );
                    },
                    child: DriverOrderItem(orderElement: item),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
