import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/core/values/order_status.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/driver_location_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/route_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/use_cases/get_route_use_case.dart';
import 'package:flowery_rider_app/features/orders/domain/use_cases/watch_driver_location_use_case.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/map_cubit/map_cubit.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/map_cubit/map_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_cubit_test.mocks.dart';

@GenerateMocks([
  WatchDriverLocationUseCase,
  GetRouteUseCase,
  FirebaseFirestore,
], customMocks: [
  MockSpec<CollectionReference<Map<String, dynamic>>>(
    as: #MockCollectionReference,
  ),
  MockSpec<DocumentReference<Map<String, dynamic>>>(
    as: #MockDocumentReference,
  ),
])
void main() {
  late MockWatchDriverLocationUseCase mockWatch;
  late MockGetRouteUseCase mockGetRoute;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDoc;
  late StreamController<DriverLocationEntity> locationController;
  late StreamController<DocumentSnapshot<Map<String, dynamic>>>
      statusController;

  const storePoint = LatLngPoint(lat: 29.0, lng: 30.0);
  const buyerPoint = LatLngPoint(lat: 30.0, lng: 31.0);
  const tRoute = RouteEntity(
    waypoints: [],
    distanceMeters: 100,
    durationSeconds: 60,
  );

  setUp(() {
    mockWatch = MockWatchDriverLocationUseCase();
    mockGetRoute = MockGetRouteUseCase();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();
    locationController = StreamController<DriverLocationEntity>();
    statusController =
        StreamController<DocumentSnapshot<Map<String, dynamic>>>();

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    when(mockDoc.snapshots()).thenAnswer((_) => statusController.stream);
    when(mockWatch.call(any)).thenAnswer((_) => locationController.stream);
    when(mockGetRoute.call(
      origin: anyNamed('origin'),
      destination: anyNamed('destination'),
    )).thenAnswer((_) async => tRoute);
  });

  tearDown(() async {
    if (!locationController.isClosed) await locationController.close();
    if (!statusController.isClosed) await statusController.close();
  });

  MapCubit buildCubit() =>
      MapCubit(mockWatch, mockGetRoute, mockFirestore);

  void init(MapCubit cubit, String status) => cubit.init(
        orderId: 'order_1',
        initialStatus: status,
        storePoint: storePoint,
        buyerPoint: buyerPoint,
      );

  test('initial state is loading with null fields', () {
    // ignore: avoid_print
    print('DEBUG 1: before buildCubit');
    final cubit = buildCubit();
    // ignore: avoid_print
    print('DEBUG 2: after buildCubit');

    expect(cubit.state, const MapState());
    // ignore: avoid_print
    print('DEBUG 3: after expect state');
    expect(cubit.state.phase, MapPhase.loading);
    // ignore: avoid_print
    print('DEBUG 4: after expect phase');
    expect(cubit.state.driverLocation, isNull);
    expect(cubit.state.destination, isNull);
    expect(cubit.state.route, isNull);
    // ignore: avoid_print
    print('DEBUG 5: end of test');
  });

  test('destination for accepted status is the store point', () async {
    final cubit = buildCubit();

    init(cubit, OrderStatus.accepted);

    expect(cubit.state.destination, same(storePoint));
    await cubit.close();
  });

  test('destination for arrivedPickup status is the store point', () async {
    final cubit = buildCubit();

    init(cubit, OrderStatus.arrivedPickup);

    expect(cubit.state.destination, same(storePoint));
    await cubit.close();
  });

  test('destination for outForDelivery status is the buyer point', () async {
    final cubit = buildCubit();

    init(cubit, OrderStatus.outForDelivery);

    expect(cubit.state.destination, same(buyerPoint));
    await cubit.close();
  });

  test('becomes ready and fetches route on first driver location', () async {
    final cubit = buildCubit();
    init(cubit, OrderStatus.outForDelivery);

    locationController.add(const DriverLocationEntity(lat: 30.1, lng: 31.1));
    await Future.delayed(const Duration(milliseconds: 100));

    expect(cubit.state.phase, MapPhase.ready);
    expect(cubit.state.driverLocation, isNotNull);
    expect(cubit.state.route, same(tRoute));
    verify(mockGetRoute.call(
      origin: anyNamed('origin'),
      destination: anyNamed('destination'),
    )).called(1);

    await cubit.close();
  });

  test('does not refetch route when driver moves less than 30m', () async {
    final cubit = buildCubit();
    init(cubit, OrderStatus.outForDelivery);

    locationController.add(const DriverLocationEntity(lat: 30.1, lng: 31.1));
    await Future.delayed(const Duration(milliseconds: 3200));
    locationController
        .add(const DriverLocationEntity(lat: 30.1001, lng: 31.1));
    await Future.delayed(const Duration(milliseconds: 300));

    verify(mockGetRoute.call(
      origin: anyNamed('origin'),
      destination: anyNamed('destination'),
    )).called(1);

    await cubit.close();
  });

  test('refetches route when driver moves more than 30m', () async {
    final cubit = buildCubit();
    init(cubit, OrderStatus.outForDelivery);

    locationController.add(const DriverLocationEntity(lat: 30.1, lng: 31.1));
    await Future.delayed(const Duration(milliseconds: 3200));
    locationController.add(const DriverLocationEntity(lat: 30.2, lng: 31.1));
    await Future.delayed(const Duration(milliseconds: 300));

    verify(mockGetRoute.call(
      origin: anyNamed('origin'),
      destination: anyNamed('destination'),
    )).called(2);

    await cubit.close();
  });

  test('close cancels subscriptions without throwing', () async {
    final cubit = buildCubit();
    init(cubit, OrderStatus.outForDelivery);

    expect(locationController.hasListener, isTrue);
    expect(statusController.hasListener, isTrue);

    await expectLater(cubit.close(), completes);

    expect(locationController.hasListener, isFalse);
    expect(statusController.hasListener, isFalse);
  });
}
