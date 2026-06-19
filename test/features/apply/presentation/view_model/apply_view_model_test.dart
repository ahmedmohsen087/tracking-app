import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/apply/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/apply/domain/entities/apply_response_entity.dart';
import 'package:flowery_rider_app/features/apply/domain/use_cases/apply_use_case.dart';
import 'package:flowery_rider_app/features/apply/presentation/view_model/apply_events.dart';
import 'package:flowery_rider_app/features/apply/presentation/view_model/apply_state.dart';
import 'package:flowery_rider_app/features/apply/presentation/view_model/apply_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'apply_view_model_test.mocks.dart';

@GenerateMocks([ApplyUseCase, AuthManager])
void main() {
  late ApplyViewModel viewModel;
  late MockApplyUseCase mockUseCase;
  late MockAuthManager mockAuthManager;

  setUpAll(() {
    provideDummy<BaseResponse<ApplyResponseEntity>>(
      SuccessBaseResponse(data: const ApplyResponseEntity()),
    );
  });

  setUp(() {
    mockUseCase = MockApplyUseCase();
    mockAuthManager = MockAuthManager();
    viewModel = ApplyViewModel(mockUseCase, mockAuthManager);
  });

  tearDown(() {
    viewModel.close();
  });

  final requestModel = ApplyRequestModel(
    country: 'Egypt',
    firstName: 'John',
    lastName: 'Doe',
    vehicleTypeId: '123',
    vehicleNumber: '1234',
    vehicleLicensePath: 'path/to/license.jpg',
    email: 'john@example.com',
    phone: '01000000000',
    nid: '12345678901234',
    nidImgPath: 'path/to/nid.jpg',
    password: 'password',
    confirmPassword: 'password',
    gender: 'male',
  );

  final successResponse = ApplyResponseEntity(
    message: 'Success',
    token: 'token123',
  );

  blocTest<ApplyViewModel, ApplyState>(
    'emits [loading, success] when apply is successful and sets auth data',
    build: () {
      when(
        mockUseCase.execute(requestModel: anyNamed('requestModel')),
      ).thenAnswer((_) async => SuccessBaseResponse(data: successResponse));
      when(
        mockAuthManager.setAuthData(
          token: anyNamed('token'),
          rememberMe: anyNamed('rememberMe'),
        ),
      ).thenAnswer((_) async {});
      return viewModel;
    },
    act: (bloc) => bloc.doEvent(SubmitApplyEvent(requestModel: requestModel)),
    expect: () => [
      predicate<ApplyState>((state) => state.applyState.isLoading),
      predicate<ApplyState>(
        (state) => state.applyState.data == successResponse,
      ),
    ],
    verify: (_) {
      verify(
        mockUseCase.execute(requestModel: anyNamed('requestModel')),
      ).called(1);
      verify(
        mockAuthManager.setAuthData(token: 'token123', rememberMe: true),
      ).called(1);
    },
  );

  blocTest<ApplyViewModel, ApplyState>(
    'emits [loading, error] when apply fails',
    build: () {
      when(
        mockUseCase.execute(requestModel: anyNamed('requestModel')),
      ).thenAnswer(
        (_) async => ErrorBaseResponse(errorMessage: 'Error occurred'),
      );
      return viewModel;
    },
    act: (bloc) => bloc.doEvent(SubmitApplyEvent(requestModel: requestModel)),
    expect: () => [
      predicate<ApplyState>((state) => state.applyState.isLoading),
      predicate<ApplyState>(
        (state) => state.applyState.msg == 'Error occurred',
      ),
    ],
  );

  blocTest<ApplyViewModel, ApplyState>(
    'emits [loading, error] when exception occurs',
    build: () {
      when(
        mockUseCase.execute(requestModel: anyNamed('requestModel')),
      ).thenThrow(Exception('Unexpected error'));
      return viewModel;
    },
    act: (bloc) => bloc.doEvent(SubmitApplyEvent(requestModel: requestModel)),
    expect: () => [
      predicate<ApplyState>((state) => state.applyState.isLoading),
      predicate<ApplyState>(
        (state) => state.applyState.msg!.contains('Unexpected error'),
      ),
    ],
  );
}
