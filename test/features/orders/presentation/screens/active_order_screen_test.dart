import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/config/di/di.dart';
import 'package:flowery_rider_app/config/firebase/fcm_service.dart';
import 'package:flowery_rider_app/features/home/domain/entities/order_entity.dart';
import 'package:flowery_rider_app/features/home/domain/entities/shipping_address_entity.dart';
import 'package:flowery_rider_app/features/home/domain/entities/store_entity.dart';
import 'package:flowery_rider_app/features/home/domain/entities/user_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/use_cases/update_order_state_use_case.dart';
import 'package:flowery_rider_app/features/orders/presentation/screens/active_order_screen.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/active_order_view_model/active_order_event.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/active_order_view_model/active_order_state.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/active_order_view_model/active_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'active_order_screen_test.mocks.dart';

class _CachedAssetLoader extends AssetLoader {
  final Map<String, dynamic> data;
  const _CachedAssetLoader(this.data);

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async => data;
}

// ignore: subtype_of_sealed_class
class _FakeDocumentRef extends Fake
    implements DocumentReference<Map<String, dynamic>> {
  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots({
    bool includeMetadataChanges = false,
    ListenSource source = ListenSource.defaultSource,
  }) => StreamController<DocumentSnapshot<Map<String, dynamic>>>().stream;
}

// ignore: subtype_of_sealed_class
class _FakeCollection extends Fake
    implements CollectionReference<Map<String, dynamic>> {
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) =>
      _FakeDocumentRef();
}

class _StubViewModel extends ActiveOrderViewModel {
  final ActiveOrderState _presetState;

  _StubViewModel({
    required this._presetState,
    required FcmService fcmService,
    required FirebaseFirestore firestore,
    required UpdateOrderStateUseCase updateOrderStateUseCase,
  }) : super(fcmService, firestore, updateOrderStateUseCase);

  @override
  void init(String orderId) {
    emit(_presetState);
  }

  @override
  void doEvent(ActiveOrderEvent event) {}
}

@GenerateMocks([FirebaseFirestore, FcmService, UpdateOrderStateUseCase])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockFcmService mockFcmService;
  late MockUpdateOrderStateUseCase mockUpdateOrderStateUseCase;
  late Map<String, dynamic> translations;

  const testOrderId = 'order-abc';
  final testOrder = OrderEntity(
    id: testOrderId,
    user: const UserEntity(
      id: 'u1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      gender: 'male',
      phone: '01000000000',
      photo: '',
    ),
    orderItems: const [],
    totalPrice: 0,
    shippingAddress: const ShippingAddressEntity(
      street: '123 Main St',
      city: 'Cairo',
      phone: '01000000000',
      lat: '0',
      long: '0',
    ),
    paymentType: 'cash',
    isPaid: false,
    isDelivered: false,
    state: 'accepted',
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
    orderNumber: '#001',
    store: const StoreEntity(
      name: 'Test Store',
      image: '',
      address: 'Store Address',
      phoneNumber: '01111111111',
      latLong: '0,0',
    ),
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    final raw = await rootBundle.loadString('assets/translations/en.json');
    translations = json.decode(raw) as Map<String, dynamic>;
  });

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockFcmService = MockFcmService();
    mockUpdateOrderStateUseCase = MockUpdateOrderStateUseCase();

    final fakeCollection = _FakeCollection();
    when(
      mockFirestore.collection(any),
    ).thenReturn(fakeCollection as CollectionReference<Map<String, dynamic>>);
  });

  tearDown(() {
    if (getIt.isRegistered<ActiveOrderViewModel>()) {
      getIt.unregister<ActiveOrderViewModel>();
    }
  });

  Widget buildScreen(ActiveOrderState state) {
    final stub = _StubViewModel(
      presetState: state,
      fcmService: mockFcmService,
      firestore: mockFirestore,
      updateOrderStateUseCase: mockUpdateOrderStateUseCase,
    );

    if (getIt.isRegistered<ActiveOrderViewModel>()) {
      getIt.unregister<ActiveOrderViewModel>();
    }
    getIt.registerFactory<ActiveOrderViewModel>(() => stub);

    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      assetLoader: _CachedAssetLoader(translations),
      child: Builder(
        builder: (context) => MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: ActiveOrderScreen(orderId: testOrderId, order: testOrder),
        ),
      ),
    );
  }

  testWidgets(
    'when status=accepted: progress bar has 5 segments and action button says "Arrived at Pickup"',
    (tester) async {
      await tester.pumpWidget(
        buildScreen(const ActiveOrderState(status: 'accepted')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Arrived at Pickup'), findsOneWidget);

      final rows = tester
          .widgetList<Row>(
            find.descendant(
              of: find.byType(ListView),
              matching: find.byType(Row),
            ),
          )
          .toList();

      expect(rows.first.children.length, 5);
    },
  );

  testWidgets(
    'when status=arrived_user and userConfirmed=false: action button is disabled',
    (tester) async {
      await tester.pumpWidget(
        buildScreen(
          const ActiveOrderState(status: 'arrived_user', userConfirmed: false),
        ),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Delivered to User'),
      );
      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'when status=arrived_user and userConfirmed=true: action button is enabled',
    (tester) async {
      await tester.pumpWidget(
        buildScreen(
          const ActiveOrderState(status: 'arrived_user', userConfirmed: true),
        ),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Delivered to User'),
      );
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'when status=delivered: shows "Complete Order" and "Cancel Order" buttons',
    (tester) async {
      await tester.pumpWidget(
        buildScreen(const ActiveOrderState(status: 'delivered')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Complete Order'), findsOneWidget);
      expect(find.text('Cancel Order'), findsOneWidget);
    },
  );
}
