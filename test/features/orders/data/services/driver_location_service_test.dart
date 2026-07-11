import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/core/values/firestore_keys.dart';
import 'package:flowery_rider_app/features/orders/data/services/driver_location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'driver_location_service_test.mocks.dart';

class MockGeolocatorPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {}

Position _position(double lat, double lng) => Position(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.fromMillisecondsSinceEpoch(0),
      accuracy: 1,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

@GenerateMocks([
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
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDoc;
  late MockGeolocatorPlatform mockGeolocator;
  late DriverLocationService service;
  late StreamController<Position> positionController;

  final GeolocatorPlatform originalPlatform = GeolocatorPlatform.instance;

  setUpAll(() {
    provideDummy<Stream<Position>>(const Stream.empty());
  });

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();
    mockGeolocator = MockGeolocatorPlatform();
    positionController = StreamController<Position>();
    GeolocatorPlatform.instance = mockGeolocator;

    service = DriverLocationService(mockFirestore);

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    when(mockDoc.update(any)).thenAnswer((_) async {});
    when(mockGeolocator.getPositionStream(
      locationSettings: anyNamed('locationSettings'),
    )).thenAnswer((_) => positionController.stream);
  });

  tearDown(() async {
    await positionController.close();
    GeolocatorPlatform.instance = originalPlatform;
  });

  test('startTracking writes driverLat/driverLng to Firestore doc on position',
      () async {
    when(mockGeolocator.checkPermission())
        .thenAnswer((_) async => LocationPermission.whileInUse);

    await service.startTracking('order_1');
    positionController.add(_position(30.5, 31.2));
    await Future.delayed(const Duration(milliseconds: 50));

    final captured =
        verify(mockDoc.update(captureAny)).captured.single as Map;
    expect(captured[FirestoreKeys.driverLat], 30.5);
    expect(captured[FirestoreKeys.driverLng], 31.2);
  });

  test('startTracking requests permission when currently denied', () async {
    when(mockGeolocator.checkPermission())
        .thenAnswer((_) async => LocationPermission.denied);
    when(mockGeolocator.requestPermission())
        .thenAnswer((_) async => LocationPermission.always);

    await service.startTracking('order_1');

    verify(mockGeolocator.requestPermission()).called(1);
    verify(mockGeolocator.getPositionStream(
      locationSettings: anyNamed('locationSettings'),
    )).called(1);
  });

  test('startTracking returns without subscribing when permission denied',
      () async {
    when(mockGeolocator.checkPermission())
        .thenAnswer((_) async => LocationPermission.denied);
    when(mockGeolocator.requestPermission())
        .thenAnswer((_) async => LocationPermission.denied);

    await service.startTracking('order_1');

    verifyNever(mockGeolocator.getPositionStream(
      locationSettings: anyNamed('locationSettings'),
    ));
    verifyNever(mockFirestore.collection(any));
  });

  test('startTracking subscribes to the position stream when granted',
      () async {
    when(mockGeolocator.checkPermission())
        .thenAnswer((_) async => LocationPermission.always);

    await service.startTracking('order_1');

    expect(positionController.hasListener, isTrue);
  });

  test('stopTracking cancels the active subscription', () async {
    when(mockGeolocator.checkPermission())
        .thenAnswer((_) async => LocationPermission.always);

    await service.startTracking('order_1');
    expect(positionController.hasListener, isTrue);

    await service.stopTracking();

    expect(positionController.hasListener, isFalse);
  });

  test('stopTracking completes without error when nothing is tracked',
      () async {
    await expectLater(service.stopTracking(), completes);
  });
}
