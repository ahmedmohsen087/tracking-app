import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/config/firebase/fcm_service.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/start_order_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/use_cases/start_order_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../api/request_models/get_orders_request.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/orders_page_entity.dart';
import '../../domain/use_cases/get_orders_use_case.dart';
import 'home_events.dart';
import 'home_state.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  static const int _firstPage = 1;
  static const _ordersCollection = 'orders';
  static const _usersCollection = 'users';

  final GetOrdersUseCase _getOrdersUseCase;
  final StartOrderUseCase _startOrderUseCase;
  final FcmService _fcmService;
  final FirebaseFirestore _firestore;

  HomeViewModel(
    this._getOrdersUseCase,
    this._startOrderUseCase,
    this._fcmService,
    this._firestore,
  ) : super(const HomeState());

  void doEvent(GetHomeEvent event) {
    switch (event) {
      case LoadHomeDataEvent():
        _loadHomeData();
      case RefreshHomeEvent():
        _getOrders(page: _firstPage, refresh: true);
      case LoadMoreOrdersEvent():
        _loadMoreOrders();
      case RejectOrderEvent():
        _removeOrder(event.orderId);
      case AcceptOrderEvent():
        _acceptOrder(event.order);
    }
  }

  void _loadHomeData() {
    _getOrders(page: _firstPage, refresh: true);
  }

  void retryLoadHomeData() {
    _getOrders(page: _firstPage, refresh: true);
  }

  void _loadMoreOrders() {
    if (state.getOrdersState.isLoading ||
        state.isLoadingMore ||
        !state.hasMorePages) {
      return;
    }
    _getOrders(page: state.currentPage + 1);
  }

  void _removeOrder(String orderId) {
    final orders = state.getOrdersState.data ?? [];
    final updatedOrders =
        orders.where((order) => order.id != orderId).toList();
    emit(
      state.copyWith(
        getOrdersState: BaseState<List<OrderEntity>>.success(updatedOrders),
      ),
    );
  }

  Future<void> _acceptOrder(OrderEntity order) async {
    emit(
      state.copyWith(
        acceptingOrderId: order.id,
        acceptOrderState: BaseState<OrderEntity>.loading(),
      ),
    );

    final response = await _startOrderUseCase(order.id);

    switch (response) {
      case ErrorBaseResponse<StartOrderEntity>():
        emit(
          state.copyWith(
            acceptOrderState:
                BaseState<OrderEntity>.error(response.errorMessage),
          ),
        );
        return;

      case SuccessBaseResponse<StartOrderEntity>():
        final startResult = response.data;
        final userId = startResult.userId.isNotEmpty
            ? startResult.userId
            : order.user.id;
        final orderId = order.id;

        try {
          await _firestore.collection(_ordersCollection).doc(orderId).set({
            'userId': userId,
            'status': 'accepted',
            'driverName': '',
            'driverPhone': '',
            'userConfirmed': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

          final userDoc = await _firestore
              .collection(_usersCollection)
              .doc(userId)
              .get();
          final fcmToken = userDoc.data()?['fcmToken'] as String?;
          final language =
              (userDoc.data()?['language'] as String?) ?? 'en';

          if (fcmToken != null && fcmToken.isNotEmpty) {
            final msgs =
                FcmService.orderStatusMessages['accepted'] ?? {};
            await _fcmService.sendNotification(
              fcmToken: fcmToken,
              titleEn: msgs['title_en'] ?? '',
              titleAr: msgs['title_ar'] ?? '',
              bodyEn: msgs['body_en'] ?? '',
              bodyAr: msgs['body_ar'] ?? '',
              language: language,
              data: {'orderId': orderId},
            );
          }
        } catch (e, s) {
          debugPrint(
              'Firestore/FCM error after accepting order $orderId: $e\n$s');
        }

        _removeOrder(orderId);
        emit(
          state.copyWith(
            clearAcceptingOrder: true,
            acceptOrderState: BaseState<OrderEntity>.success(order),
          ),
        );
    }
  }

  Future<void> _getOrders({required int page, bool refresh = false}) async {
    final isFirstPage = page == _firstPage;

    emit(
      state.copyWith(
        getOrdersState: isFirstPage
            ? BaseState<List<OrderEntity>>.loading()
            : state.getOrdersState,
        isLoadingMore: !isFirstPage,
      ),
    );

    final response = await _getOrdersUseCase(
      request: GetOrdersRequest(
        page: page,
        limit: state.limit,
      ),
    );

    switch (response) {
      case SuccessBaseResponse<OrdersPageEntity>():
        final currentOrders = refresh
            ? <OrderEntity>[]
            : state.getOrdersState.data ?? <OrderEntity>[];
        final orders = [...currentOrders, ...response.data.orders];

        emit(
          state.copyWith(
            getOrdersState: BaseState<List<OrderEntity>>.success(orders),
            currentPage: response.data.currentPage,
            totalPages: response.data.totalPages,
            limit: response.data.limit,
            isLoadingMore: false,
          ),
        );

      case ErrorBaseResponse<OrdersPageEntity>():
        final currentOrders = state.getOrdersState.data ?? <OrderEntity>[];

        emit(
          state.copyWith(
            getOrdersState: isFirstPage
                ? BaseState<List<OrderEntity>>.error(response.errorMessage)
                : BaseState<List<OrderEntity>>(
                    data: currentOrders,
                    msg: response.errorMessage,
                  ),
            isLoadingMore: false,
          ),
        );
    }
  }
}
