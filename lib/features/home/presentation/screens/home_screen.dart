import 'package:flowery_rider_app/config/di/di.dart';
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
    return BlocProvider(
      create: (context) =>
          getIt<HomeViewModel>()..doEvent(const LoadHomeDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(Assets.appBarIcon),
          ),
        ),
        body: BlocBuilder<HomeViewModel, HomeState>(
          builder: (context, state) {
            final ordersState = state.getOrdersState;
            final orders = ordersState.data ?? [];

            if (ordersState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (ordersState.msg != null) {
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

            return RefreshIndicator(
              onRefresh: () async => context.read<HomeViewModel>().doEvent(
                const RefreshHomeEvent(),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: orders.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final order = orders[index];

                  return FlowerOrderItem(
                    order: order,
                    onReject: () => context.read<HomeViewModel>().doEvent(
                      RejectOrderEvent(order.id),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
