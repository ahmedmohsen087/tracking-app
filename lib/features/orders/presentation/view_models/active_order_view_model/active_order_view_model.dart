import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/config/firebase/fcm_config.dart';
import 'package:flowery_rider_app/config/firebase/fcm_service.dart';
import 'package:flowery_rider_app/core/values/firestore_keys.dart';
import 'package:flowery_rider_app/core/values/order_status.dart';
import 'package:flowery_rider_app/features/orders/domain/use_cases/update_order_state_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'active_order_event.dart';
import 'active_order_state.dart';

@injectable
class ActiveOrderViewModel extends Cubit<ActiveOrderState> {
  final FcmService _fcmService;
  final FirebaseFirestore _firestore;
  final UpdateOrderStateUseCase _updateOrderStateUseCase;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _orderSub;

  ActiveOrderViewModel(
    this._fcmService,
    this._firestore,
    this._updateOrderStateUseCase,
  ) : super(const ActiveOrderState());

  void init(String orderId) {
    _orderSub = _firestore
        .collection(FirestoreKeys.ordersCollection)
        .doc(orderId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;
      final data = snapshot.data()!;
      emit(state.copyWith(
        orderId: orderId,
        status: data[FirestoreKeys.status] as String? ?? state.status,
        userConfirmed: data[FirestoreKeys.userConfirmed] as bool? ?? false,
        driverName: data[FirestoreKeys.driverName] as String? ?? '',
        driverPhone: data[FirestoreKeys.driverPhone] as String? ?? '',
        userId: data[FirestoreKeys.userId] as String? ?? '',
      ));
    });
  }

  void doEvent(ActiveOrderEvent event) {
    switch (event) {
      case UpdateOrderStatusEvent():
        _updateStatus(event.newStatus);
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    final orderId = state.orderId;
    if (orderId.isEmpty) return;

    emit(state.copyWith(isUpdating: true));

    try {
      await _firestore
          .collection(FirestoreKeys.ordersCollection)
          .doc(orderId)
          .update({FirestoreKeys.status: newStatus});

      final userId = state.userId;
      if (userId.isNotEmpty) {
        final userDoc = await _firestore
            .collection(FirestoreKeys.usersCollection)
            .doc(userId)
            .get();
        final fcmToken = userDoc.data()?[FirestoreKeys.fcmToken] as String?;
        final language =
            (userDoc.data()?[FirestoreKeys.language] as String?) ?? 'en';

        if (fcmToken != null && fcmToken.isNotEmpty) {
          final msgs = FcmConfig.orderStatusMessages[newStatus] ?? {};
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
      }
    } catch (e) {
      emit(state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      ));
      return;
    }

    emit(state.copyWith(isUpdating: false));
  }

  Future<void> completeOrder(String orderId) async {
    emit(state.copyWith(
      updateOrderState: BaseState.loading(),
      submittedState: OrderStatus.completed,
    ));
    final response = await _updateOrderStateUseCase(
      orderId,
      OrderStatus.completed,
    );
    if (isClosed) return;
    switch (response) {
      case SuccessBaseResponse<void>():
        emit(state.copyWith(updateOrderState: BaseState.success(null)));
      case ErrorBaseResponse<void>():
        emit(state.copyWith(
          updateOrderState: BaseState.error(response.errorMessage),
        ));
    }
  }

  Future<void> cancelOrder(String orderId) async {
    emit(state.copyWith(
      updateOrderState: BaseState.loading(),
      submittedState: OrderStatus.canceled,
    ));
    final response = await _updateOrderStateUseCase(
      orderId,
      OrderStatus.canceled,
    );
    if (isClosed) return;
    switch (response) {
      case SuccessBaseResponse<void>():
        emit(state.copyWith(updateOrderState: BaseState.success(null)));
      case ErrorBaseResponse<void>():
        emit(state.copyWith(
          updateOrderState: BaseState.error(response.errorMessage),
        ));
    }
  }

  @override
  Future<void> close() {
    _orderSub?.cancel();
    return super.close();
  }
}
