import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/config/firebase/fcm_service.dart';
import 'package:flowery_rider_app/features/home/domain/entities/order_entity.dart';
import 'package:flowery_rider_app/features/orders/presentation/screens/order_details_screen.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/order_details_view_model/order_details_event.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/order_details_view_model/order_details_state.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/order_details_view_model/order_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'order_details_screen_test.mocks.dart';

class _FakeDocumentRef extends Fake
    implements DocumentReference<Map<String, dynamic>> {
  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots({
    bool includeMetadataChanges = false,
    ListenSource source = ListenSource.defaultSource,
  }) =>
      StreamController<DocumentSnapshot<Map<String, dynamic>>>().stream;
}

class _FakeCollection extends Fake
    implements CollectionReference<Map<String, dynamic>> {
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) =>
      _FakeDocumentRef();
}

class _StubViewModel extends OrderDetailsViewModel {
  final OrderDetailsState _presetState;

  _StubViewModel({
    required OrderDetailsState presetState,
    required FcmService fcmService,
    required FirebaseFirestore firestore,
  })  : _presetState = presetState,
        super(fcmService, firestore);

  @override
  void init(String orderId) {
    emit(_presetState);
  }

  @override
  void doEvent(OrderDetailsEvent event) {

  }
}

@GenerateMocks([FirebaseFirestore, FcmService])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockFcmService mockFcmService;

  const testOrderId = 'order-abc';
  const testOrder = OrderEntity(orderItems: []);

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockFcmService = MockFcmService();

    final fakeCollection = _FakeCollection();
    when(mockFirestore.collection(any))
        .thenReturn(fakeCollection as CollectionReference<Map<String, dynamic>>);
  });

  tearDown(() {
    if (getIt.isRegistered<OrderDetailsViewModel>()) {
      getIt.unregister<OrderDetailsViewModel>();
    }
  });

  Widget _buildScreen(OrderDetailsState state) {
    final stub = _StubViewModel(
      presetState: state,
      fcmService: mockFcmService,
      firestore: mockFirestore,
    );

    if (getIt.isRegistered<OrderDetailsViewModel>()) {
      getIt.unregister<OrderDetailsViewModel>();
    }
    getIt.registerFactory<OrderDetailsViewModel>(() => stub);

    return const MaterialApp(
      home: OrderDetailsScreen(
        orderId: testOrderId,
        order: testOrder,
      ),
    );
  }

  testWidgets(
    'when status=accepted: progress bar has 5 segments and button says "Arrived at Pickup point"',
    (tester) async {
      await tester.pumpWidget(_buildScreen(const OrderDetailsState(status: 'accepted')));
      await tester.pump();

      expect(find.text('Arrived at Pickup point'), findsOneWidget);

      final rows = tester.widgetList<Row>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Row),
        ),
      ).toList();

      expect(rows.first.children.length, 5);
    },
  );

  testWidgets(
    'when status=arrived_user and userConfirmed=false: "Delivered to the user" button is disabled',
    (tester) async {
      await tester.pumpWidget(
        _buildScreen(const OrderDetailsState(
          status: 'arrived_user',
          userConfirmed: false,
        )),
      );
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Delivered to the user'),
      );
      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'when status=arrived_user and userConfirmed=true: "Delivered to the user" button is enabled',
    (tester) async {
      await tester.pumpWidget(
        _buildScreen(const OrderDetailsState(
          status: 'arrived_user',
          userConfirmed: true,
        )),
      );
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Delivered to the user'),
      );
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'when status=delivered: action button is grey/disabled',
    (tester) async {
      await tester.pumpWidget(
        _buildScreen(const OrderDetailsState(status: 'delivered')),
      );
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Delivered to the user'),
      );
      expect(button.onPressed, isNull);
    },
  );
}
