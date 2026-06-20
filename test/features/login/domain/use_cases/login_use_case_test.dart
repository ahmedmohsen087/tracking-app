import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/core/entities/user_entity.dart';
import 'package:flowery_rider_app/features/login/api/request_models/login_request_model.dart';
import 'package:flowery_rider_app/features/login/domain/repository/login_repository.dart';
import 'package:flowery_rider_app/features/login/domain/use_cases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_use_case_test.mocks.dart';

final tUserEntity = UserEntity(
  id: 'dummy',
  firstName: 'dummy',
  lastName: 'dummy',
  email: 'dummy@example.com',
  gender: 'dummy',
  phone: 'dummy',
  photo: 'dummy',
  role: 'dummy',
  wishlist: const [],
  addresses: const [],
  createdAt: DateTime.fromMillisecondsSinceEpoch(0),
);

@GenerateMocks([LoginRepository])
void main() {
  provideDummy<BaseResponse<AuthResponseEntity>>(
    SuccessBaseResponse<AuthResponseEntity>(
      data: AuthResponseEntity(
        token: 'dummy_token',
        message: '',
        userEntity: tUserEntity,
      ),
    ),
  );

  late MockLoginRepository mockRepository;
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
    userEntity: tUserEntity,
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
          mockRepository.login(email: tEmail, password: tPassword),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await useCase.execute(requestModel: tLoginRequestModel);

        // Assert
        expect(result, expectedResponse);
        verify(
          mockRepository.login(email: tEmail, password: tPassword),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should forward params to repository and return ErrorBaseResponse on failure',
      () async {
        // Arrange
        final expectedResponse = ErrorBaseResponse<AuthResponseEntity>(
          errorMessage: 'Invalid Credentials',
        );
        when(
          mockRepository.login(email: tEmail, password: tPassword),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await useCase.execute(requestModel: tLoginRequestModel);

        // Assert
        expect(result, expectedResponse);
        verify(
          mockRepository.login(email: tEmail, password: tPassword),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
