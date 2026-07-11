import 'package:flowery_rider_app/features/orders/data/data_sources_contract/map_firestore_data_source_contract.dart';
import 'package:flowery_rider_app/features/orders/data/data_sources_contract/map_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/orders/data/repository_impl/map_repository_impl.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/driver_location_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/route_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_repository_impl_test.mocks.dart';

@GenerateMocks([
  MapFirestoreDataSourceContract,
  MapRemoteDataSourceContract,
])
void main() {
  late MockMapFirestoreDataSourceContract mockFirestoreDs;
  late MockMapRemoteDataSourceContract mockRemoteDs;
  late MapRepositoryImpl repository;

  const origin = LatLngPoint(lat: 30.0, lng: 31.0);
  const destination = LatLngPoint(lat: 30.5, lng: 31.5);

  setUp(() {
    mockFirestoreDs = MockMapFirestoreDataSourceContract();
    mockRemoteDs = MockMapRemoteDataSourceContract();
    repository = MapRepositoryImpl(mockFirestoreDs, mockRemoteDs);
  });

  test('watchDriverLocation delegates to the firestore data source', () {
    final stream = Stream<DriverLocationEntity>.fromIterable(
      const [DriverLocationEntity(lat: 30.0, lng: 31.0)],
    );
    when(mockFirestoreDs.watchDriverLocation('order_1'))
        .thenAnswer((_) => stream);

    final result = repository.watchDriverLocation('order_1');

    expect(result, same(stream));
    verify(mockFirestoreDs.watchDriverLocation('order_1')).called(1);
    verifyZeroInteractions(mockRemoteDs);
  });

  test('getRoute delegates to the remote data source', () async {
    const route = RouteEntity(
      waypoints: [],
      distanceMeters: 10,
      durationSeconds: 5,
    );
    when(mockRemoteDs.getRoute(
      origin: anyNamed('origin'),
      destination: anyNamed('destination'),
    )).thenAnswer((_) async => route);

    final result = await repository.getRoute(
      origin: origin,
      destination: destination,
    );

    expect(result, same(route));
    verify(mockRemoteDs.getRoute(origin: origin, destination: destination))
        .called(1);
    verifyZeroInteractions(mockFirestoreDs);
  });
}
