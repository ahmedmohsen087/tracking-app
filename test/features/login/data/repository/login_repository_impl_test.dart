import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:flowery_rider_app/features/login/data/data_sources/login_remote_data_source.dart';
import 'package:flowery_rider_app/features/login/data/repository/login_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_repository_impl_test.mocks.dart';

@GenerateMocks([LoginRemoteDataSource, AuthManager])
void main() {
  setUpAll(() {
    final fallbackEntity = const AuthResponseEntity(token: 'dummy', user: null);
    final dummyException = Exception('dummy');

    provideDummy<BaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse<AuthResponseEntity>(data: fallbackEntity),
    );
    provideDummy<SuccessBaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse<AuthResponseEntity>(data: fallbackEntity),
    );
    provideDummy<ErrorBaseResponse<AuthResponseEntity>>(
      ErrorBaseResponse<AuthResponseEntity>(
        errorMessage: 'dummy_error',
        exception: dummyException,
      ),
    );
  });

  late MockLoginRemoteDataSource mockRemoteDataSource;
  late MockAuthManager mockAuthManager;
  late LoginRepositoryImpl repository;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tRememberMe = true;
  const tToken = 'mocked_jwt_token';

  final tAuthResponse = AuthResponse(
    token: tToken,
    message: 'Success',
    user: null,
  );

  setUp(() {
    mockRemoteDataSource = MockLoginRemoteDataSource();
    mockAuthManager = MockAuthManager();
    repository = LoginRepositoryImpl(mockRemoteDataSource, mockAuthManager);
  });

  group('login', () {
    test(
      'should return SuccessBaseResponse and save auth data when login is successful',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.login(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => tAuthResponse);

        when(
          mockAuthManager.setAuthData(
            token: anyNamed('token'),
            rememberMe: anyNamed('rememberMe'),
            userId: anyNamed('userId'),
          ),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.login(
          email: tEmail,
          password: tPassword,
          rememberMe: tRememberMe,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());

        verify(
          mockRemoteDataSource.login(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).called(1);

        verify(
          mockAuthManager.setAuthData(
            token: anyNamed('token'),
            rememberMe: anyNamed('rememberMe'),
            userId: anyNamed('userId'),
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockAuthManager);
      },
    );

    test(
      'should return ErrorBaseResponse when remote data source login throws an exception',
      () async {
        // Arrange
        final exception = Exception('Network Failure');
        when(
          mockRemoteDataSource.login(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(exception);

        // Act
        final result = await repository.login(
          email: tEmail,
          password: tPassword,
          rememberMe: tRememberMe,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());

        verify(
          mockRemoteDataSource.login(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).called(1);
        verifyNever(
          mockAuthManager.setAuthData(
            token: anyNamed('token'),
            rememberMe: anyNamed('rememberMe'),
            userId: anyNamed('userId'),
          ),
        );
      },
    );
  });
}
