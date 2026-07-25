import 'package:dio/dio.dart';
import 'package:flowery_rider_app/features/orders/data/data_sources_impl/map_remote_data_source_impl.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late MapRemoteDataSourceImpl dataSource;

  const origin = LatLngPoint(lat: 30.0, lng: 31.0);
  const destination = LatLngPoint(lat: 30.5, lng: 31.5);

  Response<Map<String, dynamic>> response(Map<String, dynamic> data) =>
      Response<Map<String, dynamic>>(
        data: data,
        requestOptions: RequestOptions(path: 'osrm'),
      );

  setUp(() {
    mockDio = MockDio();
    dataSource = MapRemoteDataSourceImpl(mockDio);
  });

  test('maps a valid OSRM response to a RouteEntity with lat/lng order',
      () async {
    when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
      (_) async => response({
        'code': 'Ok',
        'routes': [
          {
            'distance': 123.4,
            'duration': 56.7,
            'geometry': {
              'coordinates': [
                [31.0, 30.0],
                [31.5, 30.5],
              ],
            },
          },
        ],
      }),
    );

    final route = await dataSource.getRoute(
      origin: origin,
      destination: destination,
    );

    expect(route, isNotNull);
    expect(route!.waypoints.length, 2);
    expect(route.waypoints.first.lat, 30.0);
    expect(route.waypoints.first.lng, 31.0);
    expect(route.waypoints.last.lat, 30.5);
    expect(route.waypoints.last.lng, 31.5);
    expect(route.distanceMeters, 123.4);
    expect(route.durationSeconds, 56.7);
  });

  test('returns null when Dio throws', () async {
    when(mockDio.get<Map<String, dynamic>>(any)).thenThrow(
      DioException(requestOptions: RequestOptions(path: 'osrm')),
    );

    final route = await dataSource.getRoute(
      origin: origin,
      destination: destination,
    );

    expect(route, isNull);
  });

  test('returns null when routes list is empty', () async {
    when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
      (_) async => response({'code': 'Ok', 'routes': <dynamic>[]}),
    );

    final route = await dataSource.getRoute(
      origin: origin,
      destination: destination,
    );

    expect(route, isNull);
  });
}
