import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/config/firebase/fcm_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'order_details_event.dart';
import 'order_details_state.dart';

@injectable
class OrderDetailsViewModel extends Cubit<OrderDetailsState> {
  static const _ordersCollection = 'orders';
  static const _usersCollection = 'users';

  final FcmService _fcmService;
  final FirebaseFirestore _firestore;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _orderSub;

  OrderDetailsViewModel(this._fcmService, this._firestore)
      : super(const OrderDetailsState());

  void init(String orderId) {
    _orderSub = _firestore
        .collection(_ordersCollection)
        .doc(orderId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;
      final data = snapshot.data()!;
      emit(state.copyWith(
        orderId: orderId,
        status: data['status'] as String? ?? state.status,
        userConfirmed: data['userConfirmed'] as bool? ?? false,
        driverName: data['driverName'] as String? ?? '',
        driverPhone: data['driverPhone'] as String? ?? '',
        userId: data['userId'] as String? ?? '',
      ));
    });
  }

  void doEvent(OrderDetailsEvent event) {
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
      await _firestore.collection(_ordersCollection).doc(orderId).update({
        'status': newStatus,
      });

      final userId = state.userId;
      if (userId.isNotEmpty) {
        final userDoc =
            await _firestore.collection(_usersCollection).doc(userId).get();
        final fcmToken = userDoc.data()?['fcmToken'] as String?;
        final language = (userDoc.data()?['language'] as String?) ?? 'en';

        if (fcmToken != null && fcmToken.isNotEmpty) {
          final msgs = FcmService.orderStatusMessages[newStatus] ?? {};
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

  @override
  Future<void> close() {
    _orderSub?.cancel();
    return super.close();
  }
}
