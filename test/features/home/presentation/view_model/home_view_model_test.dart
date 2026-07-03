import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/home/domain/entities/orders_page_entity.dart';
import 'package:flowery_rider_app/features/home/domain/use_cases/get_orders_use_case.dart';
import 'package:flowery_rider_app/features/home/presentation/view_model/home_events.dart';
import 'package:flowery_rider_app/features/home/presentation/view_model/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_view_model_test.mocks.dart';

@GenerateMocks([GetOrdersUseCase])
void main (){
  late HomeViewModel viewModel;
  late MockGetOrdersUseCase mockGetOrdersUseCase;
  setUpAll(() {
    provideDummy<BaseResponse<OrdersPageEntity>>(
      SuccessBaseResponse(data: const OrdersPageEntity()),
    );
  });
  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    viewModel = HomeViewModel(mockGetOrdersUseCase);
  });
  test('test load home data event', () async {
    when(mockGetOrdersUseCase(request: anyNamed('request')))
        .thenAnswer((_) async => SuccessBaseResponse(data: const OrdersPageEntity()));
     viewModel.doEvent(const LoadHomeDataEvent());
    expect(viewModel.state.getOrdersState.isLoading, true);
    await Future.delayed(const Duration(seconds: 1));
    expect(viewModel.state.getOrdersState.isLoading, false);
  });

  test('test refresh home event', () async {
    when(mockGetOrdersUseCase(request: anyNamed('request')))
        .thenAnswer((_) async => SuccessBaseResponse(data: const OrdersPageEntity()));
     viewModel.doEvent(const RefreshHomeEvent());
    expect(viewModel.state.getOrdersState.isLoading, true);
    await Future.delayed(const Duration(seconds: 1));
    expect(viewModel.state.getOrdersState.isLoading, false);
  });







  }

