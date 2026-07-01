import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/login_request_model.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/driver_entity.dart';
import 'package:flowery_rider_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:flowery_rider_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_use_case_test.mocks.dart';

const tDriverEntity = DriverEntity(
  id: 'dummy',
  firstName: 'dummy',
  lastName: 'dummy',
  email: 'dummy@example.com',
  gender: 'dummy',
  phone: 'dummy',
  photo: 'dummy',
  role: 'dummy',
);

@GenerateMocks([AuthRepositoryContract])
void main() {
  provideDummy<BaseResponse<AuthResponseEntity>>(
    SuccessBaseResponse<AuthResponseEntity>(
      data: const AuthResponseEntity(
        token: 'dummy_token',
        message: '',
        driver: tDriverEntity,
      ),
    ),
  );

  late MockAuthRepositoryContract mockRepository;
  late LoginUseCase useCase;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  final tLoginRequestModel = LoginRequestModel(
    email: tEmail,
    password: tPassword,
  );

  final tAuthResponseEntity = AuthResponseEntity(
    token: 'mocked_jwt_token',
    message: 'Success',
    driver: tDriverEntity,
  );

  setUp(() {
    mockRepository = MockAuthRepositoryContract();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    test(
      'should forward params to repository and return SuccessBaseResponse on success',
      () async {

        final expectedResponse = SuccessBaseResponse<AuthResponseEntity>(
          data: tAuthResponseEntity,
        );
        when(
          mockRepository.login(
              loginRequestModel: anyNamed('loginRequestModel')),
        ).thenAnswer((_) async => expectedResponse);

        final result = await useCase.execute(
            loginRequestModel: tLoginRequestModel);

        expect(result, expectedResponse);
        verify(
          mockRepository.login(
              loginRequestModel: anyNamed('loginRequestModel')),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should forward params to repository and return ErrorBaseResponse on failure',
      () async {

        final expectedResponse = ErrorBaseResponse<AuthResponseEntity>(
          errorMessage: 'Invalid Credentials',
        );
        when(
          mockRepository.login(
              loginRequestModel: anyNamed('loginRequestModel')),
        ).thenAnswer((_) async => expectedResponse);

        final result = await useCase.execute(
            loginRequestModel: tLoginRequestModel);

        expect(result, expectedResponse);
        verify(
          mockRepository.login(
              loginRequestModel: anyNamed('loginRequestModel')),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
