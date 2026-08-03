import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/features/home/domain/entities/order_entity.dart';
import 'package:flowery_rider_app/features/orders/presentation/screens/active_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/home_events.dart';
import '../view_model/home_state.dart';
import '../view_model/home_view_model.dart';
import '../widgets/flower_order_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _onAcceptOrderListener(BuildContext context, HomeState state) {
    final order = state.acceptOrderState.data!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActiveOrderScreen(orderId: order.id, order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return BlocProvider(
      create: (_) => getIt<HomeViewModel>()..doEvent(const LoadHomeDataEvent()),
      child: BlocListener<HomeViewModel, HomeState>(
        listenWhen: (prev, curr) =>
            prev.acceptOrderState != curr.acceptOrderState &&
            curr.acceptOrderState.data != null &&
            !curr.acceptOrderState.isLoading,
        listener: _onAcceptOrderListener,
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
          body: const _HomeContentBody(),
        ),
      ),
    );
  }
}

class _HomeContentBody extends StatelessWidget {
  const _HomeContentBody();

  bool _onScrollNotification(BuildContext context, ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.pixels >= metrics.maxScrollExtent - 200) {
      context.read<HomeViewModel>().doEvent(const LoadMoreOrdersEvent());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final ordersState = state.getOrdersState;
        final orders = ordersState.data ?? [];

        if (ordersState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ordersState.msg != null && orders.isEmpty) {
          return _HomeErrorView(message: ordersState.msg!);
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (n) => _onScrollNotification(context, n),
          child: RefreshIndicator(
            onRefresh: () => context.read<HomeViewModel>().refresh(),
            child: orders.isEmpty
                ? const _HomeEmptyView()
                : _OrdersListView(
                    orders: orders,
                    acceptingOrderId: state.acceptingOrderId,
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
    required this.orders,
    required this.acceptingOrderId,
    required this.isLoadingMore,
  });

  final List<OrderEntity> orders;
  final String? acceptingOrderId;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: orders.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        if (index == orders.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = orders[index];
        final vm = context.read<HomeViewModel>();

        return FlowerOrderItem(
          order: order,
          isAccepting: acceptingOrderId == order.id,
          onReject: () => vm.doEvent(RejectOrderEvent(order.id)),
          onAccept: () => vm.doEvent(AcceptOrderEvent(order)),
        );
      },
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  const _HomeErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () =>
                context.read<HomeViewModel>().doEvent(const RefreshHomeEvent()),
            child: Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}

class _HomeEmptyView extends StatelessWidget {
  const _HomeEmptyView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Text(AppStrings.noOrdersAvailable),
          ),
        ),
      ],
    );
  }
}
