import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/route_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/repository_contract/map_repository_contract.dart';
import 'package:flowery_rider_app/features/orders/domain/use_cases/get_route_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_route_use_case_test.mocks.dart';

@GenerateMocks([MapRepositoryContract])
void main() {
  late MockMapRepositoryContract mockRepo;
  late GetRouteUseCase useCase;

  const origin = LatLngPoint(lat: 30.0, lng: 31.0);
  const destination = LatLngPoint(lat: 30.5, lng: 31.5);

  setUp(() {
    mockRepo = MockMapRepositoryContract();
    useCase = GetRouteUseCase(mockRepo);
  });

  test('call delegates to repo.getRoute', () async {
    const route = RouteEntity(
      waypoints: [],
      distanceMeters: 10,
      durationSeconds: 5,
    );
    when(mockRepo.getRoute(
      origin: anyNamed('origin'),
      destination: anyNamed('destination'),
    )).thenAnswer((_) async => route);

    final result = await useCase(origin: origin, destination: destination);

    expect(result, same(route));
    verify(mockRepo.getRoute(origin: origin, destination: destination))
        .called(1);
  });
}
