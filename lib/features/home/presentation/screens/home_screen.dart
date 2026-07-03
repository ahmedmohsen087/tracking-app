import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/values/assets.dart';
import '../view_model/home_events.dart';
import '../view_model/home_state.dart';
import '../view_model/home_view_model.dart';
import '../widgets/flower_order_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(Assets.appBarIcon),
        ),
      ),
      body: BlocBuilder<HomeViewModel, HomeState>(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(ordersState.msg!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<HomeViewModel>().doEvent(
                      const RefreshHomeEvent(),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (orders.isEmpty) {
            return const Center(child: Text('No orders available'));
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;
              final shouldLoadMore =
                  metrics.pixels >= metrics.maxScrollExtent - 200;

              if (shouldLoadMore) {
                context.read<HomeViewModel>().doEvent(
                  const LoadMoreOrdersEvent(),
                );
              }

              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async =>
                  context.read<HomeViewModel>().doEvent(
                    const RefreshHomeEvent(),
                  ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: orders.length +
                    (state.isLoadingMore ? 1 : 0),
                separatorBuilder: (_, _) =>
                const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  if (index == orders.length) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final order = orders[index];

                  return FlowerOrderItem(
                    order: order,
                    onReject: () =>
                        context.read<HomeViewModel>().doEvent(
                          RejectOrderEvent(order.id),
                        ),
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