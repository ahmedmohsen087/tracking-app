import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/home/data/data_sources_contract/home_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/home/data/models/home_response.dart';
import 'package:flowery_rider_app/features/home/data/models/metadata.dart';
import 'package:flowery_rider_app/features/home/data/repository_impl/home_repository_impl.dart';
import 'package:flowery_rider_app/features/home/domain/entities/orders_page_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_repository_impl_test.mocks.dart';

@GenerateMocks([HomeRemoteDataSourceContract])
void main() {
  late HomeRepositoryImpl repository;
  late MockHomeRemoteDataSourceContract mockDataSource;

  setUpAll(() {
    provideDummy<BaseResponse<HomeResponse>>(
      SuccessBaseResponse(data: HomeResponse()),
    );
  });

  setUp(() {
    mockDataSource = MockHomeRemoteDataSourceContract();
    repository = HomeRepositoryImpl(mockDataSource);
  });

  test('returns paginated orders with metadata on success', () async {
    final response = HomeResponse(
      orders: const [],
      metadata: Metadata(
        currentPage: 2,
        totalPages: 4,
        totalItems: 35,
        limit: 10,
      ),
    );

    when(
      mockDataSource.getOrders(page: 2, limit: 10),
    ).thenAnswer((_) async => SuccessBaseResponse(data: response));

    final result = await repository.getOrders(page: 2, limit: 10);

    expect(result, isA<SuccessBaseResponse<OrdersPageEntity>>());
    final data = (result as SuccessBaseResponse<OrdersPageEntity>).data;
    expect(data.orders, isEmpty);
    expect(data.currentPage, 2);
    expect(data.totalPages, 4);
    expect(data.totalItems, 35);
    expect(data.limit, 10);
    verify(mockDataSource.getOrders(page: 2, limit: 10)).called(1);
    verifyNoMoreInteractions(mockDataSource);
  });

  test('returns ErrorBaseResponse when data source fails', () async {
    when(
      mockDataSource.getOrders(page: 1, limit: 10),
    ).thenAnswer((_) async => ErrorBaseResponse(errorMessage: 'Error'));

    final result = await repository.getOrders(page: 1, limit: 10);

    expect(result, isA<ErrorBaseResponse<OrdersPageEntity>>());
    expect((result as ErrorBaseResponse).errorMessage, 'Error');
  });
}
