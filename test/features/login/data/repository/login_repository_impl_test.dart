import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/core/entities/user_entity.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:flowery_rider_app/features/login/data/data_sources/login_remote_data_source.dart';
import 'package:flowery_rider_app/features/login/data/repository/login_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_repository_impl_test.mocks.dart';

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

@GenerateMocks([LoginRemoteDataSource, AuthManager])
void main() {
  setUpAll(() {
    final fallbackEntity = AuthResponseEntity(
      token: 'dummy',
      message: '',
      userEntity: tUserEntity,
    );

    provideDummy<BaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse<AuthResponseEntity>(data: fallbackEntity),
    );
    provideDummy<SuccessBaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse<AuthResponseEntity>(data: fallbackEntity),
    );
    provideDummy<ErrorBaseResponse<AuthResponseEntity>>(
      ErrorBaseResponse<AuthResponseEntity>(errorMessage: 'dummy_error'),
    );
    provideDummy<BaseResponse<AuthResponse>>(
      ErrorBaseResponse<AuthResponse>(errorMessage: 'dummy_error'),
    );
  });

  late MockLoginRemoteDataSource mockRemoteDataSource;
  late MockAuthManager mockAuthManager;
  late LoginRepositoryImpl repository;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
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
        ).thenAnswer(
          (_) async => SuccessBaseResponse<AuthResponse>(data: tAuthResponse),
        );

        when(
          mockAuthManager.setAuthData(token: anyNamed('token')),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.login(
          email: tEmail,
          password: tPassword,
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
          mockAuthManager.setAuthData(token: anyNamed('token')),
        ).called(1);

        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockAuthManager);
      },
    );

    test(
      'should return ErrorBaseResponse when remote data source login fails',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.login(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<AuthResponse>(
            errorMessage: 'Network Failure',
          ),
        );

        // Act
        final result = await repository.login(
          email: tEmail,
          password: tPassword,
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
          mockAuthManager.setAuthData(token: anyNamed('token')),
        );
      },
    );
  });
}
