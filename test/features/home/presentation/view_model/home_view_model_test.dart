import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/home/domain/entities/order_entity.dart';
import 'package:flowery_rider_app/features/home/domain/entities/orders_page_entity.dart';
import 'package:flowery_rider_app/features/home/domain/use_cases/get_orders_use_case.dart';
import 'package:flowery_rider_app/features/home/presentation/view_model/home_events.dart';
import 'package:flowery_rider_app/features/home/presentation/view_model/home_state.dart';
import 'package:flowery_rider_app/features/home/presentation/view_model/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_view_model_test.mocks.dart';

@GenerateMocks([GetOrdersUseCase])
void main() {
  late MockGetOrdersUseCase mockUseCase;
  late HomeViewModel sut;

  const firstOrder = OrderEntity(id: '1');
  const secondOrder = OrderEntity(id: '2');

  setUpAll(() {
    provideDummy<BaseResponse<OrdersPageEntity>>(
      SuccessBaseResponse(data: const OrdersPageEntity()),
    );
  });

  setUp(() {
    mockUseCase = MockGetOrdersUseCase();
    sut = HomeViewModel(mockUseCase);
  });

  tearDown(() => sut.close());

  blocTest<HomeViewModel, HomeState>(
    'loads first page and stores pagination metadata',
    build: () {
      when(mockUseCase(page: 1, limit: 10)).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const OrdersPageEntity(
            orders: [firstOrder],
            currentPage: 1,
            totalPages: 2,
            totalItems: 2,
            limit: 10,
          ),
        ),
      );
      return sut;
    },
    act: (vm) => vm.doEvent(const LoadHomeDataEvent()),
    expect: () => [
      isA<HomeState>().having(
        (state) => state.getOrdersState.isLoading,
        'isLoading',
        isTrue,
      ),
      isA<HomeState>()
          .having((state) => state.getOrdersState.data, 'orders', [firstOrder])
          .having((state) => state.currentPage, 'currentPage', 1)
          .having((state) => state.totalPages, 'totalPages', 2),
    ],
    verify: (_) {
      verify(mockUseCase(page: 1, limit: 10)).called(1);
      verifyNoMoreInteractions(mockUseCase);
    },
  );

  blocTest<HomeViewModel, HomeState>(
    'appends next page when LoadMoreOrdersEvent is dispatched',
    build: () {
      when(mockUseCase(page: 1, limit: 10)).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const OrdersPageEntity(
            orders: [firstOrder],
            currentPage: 1,
            totalPages: 2,
            limit: 10,
          ),
        ),
      );
      when(mockUseCase(page: 2, limit: 10)).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const OrdersPageEntity(
            orders: [secondOrder],
            currentPage: 2,
            totalPages: 2,
            limit: 10,
          ),
        ),
      );
      return sut;
    },
    act: (vm) async {
      vm.doEvent(const LoadHomeDataEvent());
      await Future<void>.delayed(Duration.zero);
      vm.doEvent(const LoadMoreOrdersEvent());
    },
    expect: () => [
      isA<HomeState>().having(
        (state) => state.getOrdersState.isLoading,
        'isLoading',
        isTrue,
      ),
      isA<HomeState>().having(
        (state) => state.getOrdersState.data,
        'first page orders',
        [firstOrder],
      ),
      isA<HomeState>().having(
        (state) => state.isLoadingMore,
        'isLoadingMore',
        isTrue,
      ),
      isA<HomeState>()
          .having((state) => state.getOrdersState.data, 'combined orders', [
            firstOrder,
            secondOrder,
          ])
          .having((state) => state.currentPage, 'currentPage', 2)
          .having((state) => state.hasMorePages, 'hasMorePages', isFalse),
    ],
  );

  blocTest<HomeViewModel, HomeState>(
    'removes rejected order from current state',
    build: () {
      when(mockUseCase(page: 1, limit: 10)).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const OrdersPageEntity(
            orders: [firstOrder, secondOrder],
            currentPage: 1,
            totalPages: 1,
            limit: 10,
          ),
        ),
      );
      return sut;
    },
    act: (vm) async {
      vm.doEvent(const LoadHomeDataEvent());
      await Future<void>.delayed(Duration.zero);
      vm.doEvent(const RejectOrderEvent('1'));
    },
    skip: 2,
    expect: () => [
      isA<HomeState>().having(
        (state) => state.getOrdersState.data,
        'orders after reject',
        [secondOrder],
      ),
    ],
  );
}
