import 'package:flowery_rider_app/features/orders/domain/entities/driver_location_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/repository_contract/map_repository_contract.dart';
import 'package:flowery_rider_app/features/orders/domain/use_cases/watch_driver_location_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watch_driver_location_use_case_test.mocks.dart';

@GenerateMocks([MapRepositoryContract])
void main() {
  late MockMapRepositoryContract mockRepo;
  late WatchDriverLocationUseCase useCase;

  setUp(() {
    mockRepo = MockMapRepositoryContract();
    useCase = WatchDriverLocationUseCase(mockRepo);
  });

  test('call delegates to repo.watchDriverLocation', () {
    final stream = Stream<DriverLocationEntity>.fromIterable(
      const [DriverLocationEntity(lat: 30.0, lng: 31.0)],
    );
    when(mockRepo.watchDriverLocation('order_1')).thenAnswer((_) => stream);

    final result = useCase('order_1');

    expect(result, same(stream));
    verify(mockRepo.watchDriverLocation('order_1')).called(1);
  });
}
