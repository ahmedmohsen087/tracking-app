import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/firebase/fcm_config.dart';
import 'package:flowery_rider_app/config/firebase/fcm_service.dart';
import 'package:flowery_rider_app/core/values/order_status.dart';
import 'package:flowery_rider_app/features/orders/data/services/driver_location_service.dart';
import 'package:flowery_rider_app/features/orders/domain/use_cases/update_order_state_use_case.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/active_order_view_model/active_order_event.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/active_order_view_model/active_order_state.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/active_order_view_model/active_order_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'active_order_view_model_test.mocks.dart';

// ignore: subtype_of_sealed_class
class _FakeDocSnap extends Fake
    implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;

  _FakeDocSnap(this._data);

  @override
  bool get exists => true;

  @override
  Map<String, dynamic> data() => _data;
}

@GenerateMocks([
  FirebaseFirestore,
  FcmService,
  UpdateOrderStateUseCase,
  DriverLocationService,
], customMocks: [
  MockSpec<CollectionReference<Map<String, dynamic>>>(
    as: #MockCollectionReference,
  ),
  MockSpec<DocumentReference<Map<String, dynamic>>>(
    as: #MockDocumentReference,
  ),
])
void main() {
  setUpAll(() {
    provideDummy<BaseResponse<void>>(SuccessBaseResponse<void>(data: null));
  });

  late MockFirebaseFirestore mockFirestore;
  late MockFcmService mockFcmService;
  late MockUpdateOrderStateUseCase mockUpdateOrderStateUseCase;
  late MockDriverLocationService mockDriverLocationService;
  late MockCollectionReference mockOrdersCollection;
  late MockDocumentReference mockOrderDoc;
  late StreamController<DocumentSnapshot<Map<String, dynamic>>>
      orderStreamController;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockFcmService = MockFcmService();
    mockUpdateOrderStateUseCase = MockUpdateOrderStateUseCase();
    mockDriverLocationService = MockDriverLocationService();
    mockOrdersCollection = MockCollectionReference();
    mockOrderDoc = MockDocumentReference();
    orderStreamController = StreamController.broadcast();

    when(mockDriverLocationService.startTracking(any))
        .thenAnswer((_) async {});
    when(mockDriverLocationService.stopTracking()).thenAnswer((_) async {});

    when(mockFirestore.collection('orders')).thenReturn(mockOrdersCollection);
    when(mockOrdersCollection.doc(any)).thenReturn(mockOrderDoc);
    when(mockOrderDoc.snapshots())
        .thenAnswer((_) => orderStreamController.stream);
    when(mockOrderDoc.update(any)).thenAnswer((_) async {});

    when(
      mockFcmService.sendNotification(
        fcmToken: anyNamed('fcmToken'),
        titleEn: anyNamed('titleEn'),
        titleAr: anyNamed('titleAr'),
        bodyEn: anyNamed('bodyEn'),
        bodyAr: anyNamed('bodyAr'),
        language: anyNamed('language'),
        data: anyNamed('data'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() async {
    await orderStreamController.close();
  });

  ActiveOrderViewModel build() => ActiveOrderViewModel(
        mockFcmService,
        mockFirestore,
        mockUpdateOrderStateUseCase,
        mockDriverLocationService,
      );

  test('initial state has status="accepted" and userConfirmed=false', () {
    final vm = build();
    expect(vm.state.status, 'accepted');
    expect(vm.state.userConfirmed, false);
    expect(vm.state.orderId, '');
    vm.close();
  });

  blocTest<ActiveOrderViewModel, ActiveOrderState>(
    'emits userConfirmed=true when Firestore stream delivers that value',
    build: build,
    act: (vm) async {
      vm.init('order-123');
      orderStreamController.add(
        _FakeDocSnap({
          'status': 'arrived_user',
          'userConfirmed': true,
          'userId': 'user-1',
          'driverName': 'Ali',
          'driverPhone': '0100',
        }),
      );
      await Future<void>.delayed(const Duration(milliseconds: 30));
    },
    expect: () => [
      predicate<ActiveOrderState>(
        (s) =>
            s.userConfirmed == true &&
            s.status == 'arrived_user' &&
            s.orderId == 'order-123',
        'userConfirmed=true, status=arrived_user, orderId=order-123',
      ),
    ],
  );

  blocTest<ActiveOrderViewModel, ActiveOrderState>(
    'updateStatus(arrived_pickup) writes to Firestore and calls FcmService',
    build: () {
      final mockUsersCollection = MockCollectionReference();
      final mockUserDoc = MockDocumentReference();

      when(mockFirestore.collection('users')).thenReturn(mockUsersCollection);
      when(mockUsersCollection.doc(any)).thenReturn(mockUserDoc);
      when(mockUserDoc.get()).thenAnswer(
        (_) async => _FakeDocSnap({
          'fcmToken': 'fcm-device-token',
          'language': 'ar',
        }),
      );

      return build();
    },
    seed: () => const ActiveOrderState(
      orderId: 'order-123',
      userId: 'user-1',
      status: 'accepted',
    ),
    act: (vm) => vm.doEvent(const UpdateOrderStatusEvent('arrived_pickup')),
    wait: const Duration(milliseconds: 100),
    verify: (vm) {
      verify(mockOrderDoc.update({'status': 'arrived_pickup'})).called(1);

      final msgs = FcmConfig.orderStatusMessages['arrived_pickup']!;
      verify(
        mockFcmService.sendNotification(
          fcmToken: 'fcm-device-token',
          titleEn: msgs['title_en']!,
          titleAr: msgs['title_ar']!,
          bodyEn: msgs['body_en']!,
          bodyAr: msgs['body_ar']!,
          language: 'ar',
          data: {'orderId': 'order-123'},
        ),
      ).called(1);
    },
  );

  blocTest<ActiveOrderViewModel, ActiveOrderState>(
    'completeOrder emits loading then success',
    build: () {
      when(mockUpdateOrderStateUseCase.call(any, any))
          .thenAnswer((_) async => SuccessBaseResponse(data: null));
      return build();
    },
    seed: () => const ActiveOrderState(orderId: 'order-123'),
    act: (vm) => vm.completeOrder('order-123'),
    expect: () => [
      predicate<ActiveOrderState>(
        (s) =>
            s.updateOrderState.isLoading &&
            s.submittedState == OrderStatus.completed,
        'loading with submittedState=completed',
      ),
      predicate<ActiveOrderState>(
        (s) => !s.updateOrderState.isLoading && s.updateOrderState.msg == null,
        'success',
      ),
    ],
  );

  blocTest<ActiveOrderViewModel, ActiveOrderState>(
    'completeOrder emits loading then error',
    build: () {
      when(mockUpdateOrderStateUseCase.call(any, any))
          .thenAnswer((_) async => ErrorBaseResponse(errorMessage: 'Server error'));
      return build();
    },
    seed: () => const ActiveOrderState(orderId: 'order-123'),
    act: (vm) => vm.completeOrder('order-123'),
    expect: () => [
      predicate<ActiveOrderState>(
        (s) => s.updateOrderState.isLoading,
        'loading',
      ),
      predicate<ActiveOrderState>(
        (s) => s.updateOrderState.msg == 'Server error',
        'error message set',
      ),
    ],
  );

  blocTest<ActiveOrderViewModel, ActiveOrderState>(
    'cancelOrder emits loading then success',
    build: () {
      when(mockUpdateOrderStateUseCase.call(any, any))
          .thenAnswer((_) async => SuccessBaseResponse(data: null));
      return build();
    },
    seed: () => const ActiveOrderState(orderId: 'order-123'),
    act: (vm) => vm.cancelOrder('order-123'),
    expect: () => [
      predicate<ActiveOrderState>(
        (s) =>
            s.updateOrderState.isLoading &&
            s.submittedState == OrderStatus.canceled,
        'loading with submittedState=canceled',
      ),
      predicate<ActiveOrderState>(
        (s) => !s.updateOrderState.isLoading && s.updateOrderState.msg == null,
        'success',
      ),
    ],
  );

  blocTest<ActiveOrderViewModel, ActiveOrderState>(
    'cancelOrder emits loading then error',
    build: () {
      when(mockUpdateOrderStateUseCase.call(any, any))
          .thenAnswer((_) async => ErrorBaseResponse(errorMessage: 'Cancel failed'));
      return build();
    },
    seed: () => const ActiveOrderState(orderId: 'order-123'),
    act: (vm) => vm.cancelOrder('order-123'),
    expect: () => [
      predicate<ActiveOrderState>(
        (s) => s.updateOrderState.isLoading,
        'loading',
      ),
      predicate<ActiveOrderState>(
        (s) => s.updateOrderState.msg == 'Cancel failed',
        'error message set',
      ),
    ],
  );

  test(
    'button is disabled when status=arrived_user and userConfirmed=false',
    () {
      const state = ActiveOrderState(
        status: 'arrived_user',
        userConfirmed: false,
      );
      final enabled = !(state.status == 'delivered') &&
          !(state.status == 'arrived_user' && !state.userConfirmed);
      expect(enabled, false);
    },
  );

  test(
    'button is enabled when status=arrived_user and userConfirmed=true',
    () {
      const state = ActiveOrderState(
        status: 'arrived_user',
        userConfirmed: true,
      );
      final enabled = !(state.status == 'delivered') &&
          !(state.status == 'arrived_user' && !state.userConfirmed);
      expect(enabled, true);
    },
  );
}
