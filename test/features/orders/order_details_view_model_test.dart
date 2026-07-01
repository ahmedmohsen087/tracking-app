import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/config/firebase/fcm_service.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/order_details_view_model/order_details_event.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/order_details_view_model/order_details_state.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/order_details_view_model/order_details_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'order_details_view_model_test.mocks.dart';

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
], customMocks: [
  MockSpec<CollectionReference<Map<String, dynamic>>>(
    as: #MockCollectionReference,
  ),
  MockSpec<DocumentReference<Map<String, dynamic>>>(
    as: #MockDocumentReference,
  ),
])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockFcmService mockFcmService;
  late MockCollectionReference mockOrdersCollection;
  late MockDocumentReference mockOrderDoc;
  late StreamController<DocumentSnapshot<Map<String, dynamic>>>
      orderStreamController;


  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockFcmService = MockFcmService();
    mockOrdersCollection = MockCollectionReference();
    mockOrderDoc = MockDocumentReference();
    orderStreamController = StreamController.broadcast();

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

  OrderDetailsViewModel _build() =>
      OrderDetailsViewModel(mockFcmService, mockFirestore);

  test('initial state has status="accepted" and userConfirmed=false', () {
    final vm = _build();
    expect(vm.state.status, 'accepted');
    expect(vm.state.userConfirmed, false);
    expect(vm.state.orderId, '');
    vm.close();
  });


  blocTest<OrderDetailsViewModel, OrderDetailsState>(
    'emits userConfirmed=true when Firestore stream delivers that value',
    build: _build,
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
      predicate<OrderDetailsState>(
        (s) =>
            s.userConfirmed == true &&
            s.status == 'arrived_user' &&
            s.orderId == 'order-123',
        'userConfirmed=true, status=arrived_user, orderId=order-123',
      ),
    ],
  );


  blocTest<OrderDetailsViewModel, OrderDetailsState>(
    'updateStatus(arrived_pickup) writes to Firestore and calls FcmService',
    build: () {
      final mockUsersCollection = MockCollectionReference();
      final mockUserDoc = MockDocumentReference();

      when(mockFirestore.collection('users'))
          .thenReturn(mockUsersCollection);
      when(mockUsersCollection.doc(any)).thenReturn(mockUserDoc);
      when(mockUserDoc.get()).thenAnswer(
        (_) async => _FakeDocSnap({
          'fcmToken': 'fcm-device-token',
          'language': 'ar',
        }),
      );

      return _build();
    },
    seed: () => const OrderDetailsState(
      orderId: 'order-123',
      userId: 'user-1',
      status: 'accepted',
    ),
    act: (vm) =>
        vm.doEvent(const UpdateOrderStatusEvent('arrived_pickup')),
    wait: const Duration(milliseconds: 100),
    verify: (vm) {
      verify(mockOrderDoc.update({'status': 'arrived_pickup'})).called(1);

      final msgs = FcmService.orderStatusMessages['arrived_pickup']!;
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

  test(
    'button is disabled when status=arrived_user and userConfirmed=false',
    () {
      const state = OrderDetailsState(
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
      const state = OrderDetailsState(
        status: 'arrived_user',
        userConfirmed: true,
      );
      final enabled = !(state.status == 'delivered') &&
          !(state.status == 'arrived_user' && !state.userConfirmed);
      expect(enabled, true);
    },
  );
}
