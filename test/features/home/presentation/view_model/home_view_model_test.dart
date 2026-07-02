import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/firebase/fcm_service.dart';
import 'package:flowery_rider_app/features/home/domain/entities/orders_page_entity.dart';
import 'package:flowery_rider_app/features/home/domain/use_cases/get_orders_use_case.dart';
import 'package:flowery_rider_app/features/home/presentation/view_model/home_events.dart';
import 'package:flowery_rider_app/features/home/presentation/view_model/home_view_model.dart';
import 'package:flowery_rider_app/features/orders/domain/use_cases/start_order_use_case.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_view_model_test.mocks.dart';

@GenerateMocks([
  GetOrdersUseCase,
  StartOrderUseCase,
  GetProfileUseCase,
  FcmService,
  FirebaseFirestore,
])
void main (){
  late HomeViewModel viewModel;
  late MockGetOrdersUseCase mockGetOrdersUseCase;
  late MockStartOrderUseCase mockStartOrderUseCase;
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockFcmService mockFcmService;
  late MockFirebaseFirestore mockFirestore;
  setUpAll(() {
    provideDummy<BaseResponse<OrdersPageEntity>>(
      SuccessBaseResponse(data: const OrdersPageEntity()),
    );
  });
  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    mockStartOrderUseCase = MockStartOrderUseCase();
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockFcmService = MockFcmService();
    mockFirestore = MockFirebaseFirestore();
    viewModel = HomeViewModel(
      mockGetOrdersUseCase,
      mockStartOrderUseCase,
      mockGetProfileUseCase,
      mockFcmService,
      mockFirestore,
    );
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

