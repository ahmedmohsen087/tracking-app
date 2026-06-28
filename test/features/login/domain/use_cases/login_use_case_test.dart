import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/login/api/request_models/login_request_model.dart';
import 'package:flowery_rider_app/features/login/domain/repository/login_repository.dart';
import 'package:flowery_rider_app/features/login/domain/use_cases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_use_case_test.mocks.dart';

@GenerateMocks([LoginRepository])
void main() {
  provideDummy<BaseResponse<AuthResponseEntity>>(
    SuccessBaseResponse<AuthResponseEntity>(
      data: const AuthResponseEntity(token: 'dummy_token', user: null),
    ),
  );

  late MockLoginRepository mockRepository;
  late LoginUseCase useCase;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tRememberMe = true;

  final tLoginRequestModel = LoginRequestModel(
    email: tEmail,
    password: tPassword,
    rememberMe: tRememberMe,
  );

  const tAuthResponseEntity = AuthResponseEntity(
    token: 'mocked_jwt_token',
    user: null,
  );

  setUp(() {
    mockRepository = MockLoginRepository();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    test(
      'should forward params to repository and return SuccessBaseResponse on success',
      () async {
        // Arrange
        final expectedResponse = SuccessBaseResponse<AuthResponseEntity>(
          data: tAuthResponseEntity,
        );
        when(
          mockRepository.login(
            email: tEmail,
            password: tPassword,
            rememberMe: tRememberMe,
          ),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await useCase.execute(requestModel: tLoginRequestModel);

        // Assert
        expect(result, expectedResponse);
        verify(
          mockRepository.login(
            email: tEmail,
            password: tPassword,
            rememberMe: tRememberMe,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should forward params to repository and return ErrorBaseResponse on failure',
      () async {
        // Arrange
        final exception = Exception('Invalid Credentials');
        final expectedResponse = ErrorBaseResponse<AuthResponseEntity>(
          errorMessage: 'Invalid Credentials',
          exception: exception,
        );
        when(
          mockRepository.login(
            email: tEmail,
            password: tPassword,
            rememberMe: tRememberMe,
          ),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await useCase.execute(requestModel: tLoginRequestModel);

        // Assert
        expect(result, expectedResponse);
        verify(
          mockRepository.login(
            email: tEmail,
            password: tPassword,
            rememberMe: tRememberMe,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
