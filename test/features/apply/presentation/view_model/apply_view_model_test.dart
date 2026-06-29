import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/auth/domain/use_cases/apply_use_case.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/apply_view_model/apply_events.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/apply_view_model/apply_state.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/apply_view_model/apply_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'apply_view_model_test.mocks.dart';

@GenerateMocks([ApplyUseCase])
void main() {
  late ApplyViewModel viewModel;
  late MockApplyUseCase mockUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse(data: const AuthResponseEntity()),
    );
  });

  setUp(() {
    mockUseCase = MockApplyUseCase();
    viewModel = ApplyViewModel(mockUseCase);
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

  final successResponse = AuthResponseEntity(
    message: 'Success',
    token: 'token123',
  );

  blocTest<ApplyViewModel, ApplyState>(
    'emits [loading, success] when apply is successful',
    build: () {
      when(
        mockUseCase.execute(applyRequestModel: anyNamed('applyRequestModel')),
      ).thenAnswer((_) async => SuccessBaseResponse(data: successResponse));
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
        mockUseCase.execute(applyRequestModel: anyNamed('applyRequestModel')),
      ).called(1);
    },
  );

  blocTest<ApplyViewModel, ApplyState>(
    'emits [loading, error] when apply fails',
    build: () {
      when(
        mockUseCase.execute(applyRequestModel: anyNamed('applyRequestModel')),
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
}
