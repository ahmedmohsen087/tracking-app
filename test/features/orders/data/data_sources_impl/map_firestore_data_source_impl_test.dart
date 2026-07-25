import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/core/values/firestore_keys.dart';
import 'package:flowery_rider_app/features/orders/data/data_sources_impl/map_firestore_data_source_impl.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/driver_location_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_firestore_data_source_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
], customMocks: [
  MockSpec<CollectionReference<Map<String, dynamic>>>(
    as: #MockCollectionReference,
  ),
  MockSpec<DocumentReference<Map<String, dynamic>>>(
    as: #MockDocumentReference,
  ),
  MockSpec<DocumentSnapshot<Map<String, dynamic>>>(
    as: #MockDocumentSnapshot,
  ),
])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDoc;
  late MapFirestoreDataSourceImpl dataSource;
  late StreamController<DocumentSnapshot<Map<String, dynamic>>> controller;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();
    controller = StreamController<DocumentSnapshot<Map<String, dynamic>>>();
    dataSource = MapFirestoreDataSourceImpl(mockFirestore);

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    when(mockDoc.snapshots()).thenAnswer((_) => controller.stream);
  });

  tearDown(() async {
    if (!controller.isClosed) await controller.close();
  });

  test('maps a snapshot with driverLat/driverLng to DriverLocationEntity',
      () async {
    final snap = MockDocumentSnapshot();
    when(snap.data()).thenReturn({
      FirestoreKeys.driverLat: 30.5,
      FirestoreKeys.driverLng: 31.2,
    });

    final stream = dataSource.watchDriverLocation('order_1');

    final expectation = expectLater(
      stream,
      emits(
        isA<DriverLocationEntity>()
            .having((e) => e.lat, 'lat', 30.5)
            .having((e) => e.lng, 'lng', 31.2),
      ),
    );

    controller.add(snap);
    await expectation;
  });

  test('filters out snapshots missing driverLng', () async {
    final snap = MockDocumentSnapshot();
    when(snap.data()).thenReturn({FirestoreKeys.driverLat: 30.5});

    final stream = dataSource.watchDriverLocation('order_1');

    final expectation = expectLater(stream, emitsInOrder([emitsDone]));

    controller.add(snap);
    await controller.close();
    await expectation;
  });

  test('filters out snapshots missing driverLat', () async {
    final snap = MockDocumentSnapshot();
    when(snap.data()).thenReturn({FirestoreKeys.driverLng: 31.2});

    final stream = dataSource.watchDriverLocation('order_1');

    final expectation = expectLater(stream, emitsInOrder([emitsDone]));

    controller.add(snap);
    await controller.close();
    await expectation;
  });
}
