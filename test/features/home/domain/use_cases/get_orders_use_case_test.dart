import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/home/domain/entities/orders_page_entity.dart';
import 'package:flowery_rider_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:flowery_rider_app/features/home/domain/use_cases/get_orders_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_orders_use_case_test.mocks.dart';

@GenerateMocks([HomeRepositoryContract])
void main() {
  late GetOrdersUseCase useCase;
  late MockHomeRepositoryContract mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<OrdersPageEntity>>(
      SuccessBaseResponse(data: const OrdersPageEntity()),
    );
  });

  setUp(() {
    mockRepository = MockHomeRepositoryContract();
    useCase = GetOrdersUseCase(mockRepository);
  });

  test('passes page and limit to repository', () async {
    const response = OrdersPageEntity(currentPage: 2, totalPages: 3);

    when(
      mockRepository.getOrders(page: 2, limit: 10),
    ).thenAnswer((_) async => SuccessBaseResponse(data: response));

    final result = await useCase(page: 2, limit: 10);

    expect(result, isA<SuccessBaseResponse<OrdersPageEntity>>());
    expect((result as SuccessBaseResponse<OrdersPageEntity>).data, response);
    verify(mockRepository.getOrders(page: 2, limit: 10)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
