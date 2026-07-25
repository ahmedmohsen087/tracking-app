import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/orders/presentation/screens/active_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/text_styles.dart';
import '../view_model/home_events.dart';
import '../view_model/home_state.dart';
import '../view_model/home_view_model.dart';
import '../widgets/flower_order_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return BlocProvider(
      create: (context) =>
          getIt<HomeViewModel>()..doEvent(const LoadHomeDataEvent()),
      child: BlocListener<HomeViewModel, HomeState>(
        listenWhen: (previous, current) =>
            previous.acceptOrderState != current.acceptOrderState &&
            current.acceptOrderState.data != null &&
            !current.acceptOrderState.isLoading,
        listener: (context, state) {
          final order = state.acceptOrderState.data!;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ActiveOrderScreen(orderId: order.id, order: order),
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppStrings.appName,
                style: TextStyles.appNameTextStyle,
              ),
            ),
          ),
          body: BlocBuilder<HomeViewModel, HomeState>(
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
                        onPressed: () => context
                            .read<HomeViewModel>()
                            .doEvent(const RefreshHomeEvent()),
                        child: Text(AppStrings.retry),
                      ),
                    ],
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  final metrics = notification.metrics;
                  if (metrics.pixels >= metrics.maxScrollExtent - 200) {
                    context
                        .read<HomeViewModel>()
                        .doEvent(const LoadMoreOrdersEvent());
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: () => context.read<HomeViewModel>().refresh(),
                  child: orders.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.7,
                              child: Center(
                                child: Text(AppStrings.noOrdersAvailable),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          itemCount:
                              orders.length + (state.isLoadingMore ? 1 : 0),
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
                              isAccepting:
                                  state.acceptingOrderId == order.id,
                              onReject: () => context
                                  .read<HomeViewModel>()
                                  .doEvent(RejectOrderEvent(order.id)),
                              onAccept: () => context
                                  .read<HomeViewModel>()
                                  .doEvent(AcceptOrderEvent(order)),
                            );
                          },
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
