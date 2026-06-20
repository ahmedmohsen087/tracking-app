import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:flowery_rider_app/features/logout/data/data_sources/logout_remote_data_source.dart';
import 'package:flowery_rider_app/features/logout/data/repository/logout_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_repository_impl_test.mocks.dart';

@GenerateMocks([LogoutRemoteDataSource, AuthManager])
void main() {
  provideDummy<BaseResponse<AuthResponse>>(
    SuccessBaseResponse<AuthResponse>(data: AuthResponse()),
  );

  late MockLogoutRemoteDataSource mockRemoteDataSource;
  late MockAuthManager mockAuthManager;
  late LogoutRepositoryImpl repository;

  final tAuthResponse = AuthResponse(message: 'Success', token: 'token');

  setUp(() {
    mockRemoteDataSource = MockLogoutRemoteDataSource();
    mockAuthManager = MockAuthManager();
    repository = LogoutRepositoryImpl(mockRemoteDataSource, mockAuthManager);
  });

  group('logout', () {
    test(
      'should return SuccessBaseResponse when both remote datasource and auth manager succeed',
      () async {
        // Arrange
        when(mockRemoteDataSource.logout()).thenAnswer(
          (_) async => SuccessBaseResponse<AuthResponse>(data: tAuthResponse),
        );
        when(mockAuthManager.logout()).thenAnswer((_) async {});

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, isA<SuccessBaseResponse<AuthResponse>>());

        verify(mockRemoteDataSource.logout()).called(1);
        verify(mockAuthManager.logout()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockAuthManager);
      },
    );

    test(
      'should still clear local session and return SuccessBaseResponse when remote logout fails',
      () async {
        // Arrange: server call failed, but the user must still be logged out locally
        when(mockRemoteDataSource.logout()).thenAnswer(
          (_) async =>
              ErrorBaseResponse<AuthResponse>(errorMessage: 'Remote Fail'),
        );
        when(mockAuthManager.logout()).thenAnswer((_) async {});

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, isA<SuccessBaseResponse<AuthResponse>>());

        verify(mockRemoteDataSource.logout()).called(1);
        verify(mockAuthManager.logout()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockAuthManager);
      },
    );

    test(
      'should return ErrorBaseResponse when auth manager fails to clear local session',
      () async {
        // Arrange
        when(mockRemoteDataSource.logout()).thenAnswer(
          (_) async => SuccessBaseResponse<AuthResponse>(data: tAuthResponse),
        );
        when(mockAuthManager.logout()).thenThrow(Exception('Cache Clear Fail'));

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, isA<ErrorBaseResponse<AuthResponse>>());

        verify(mockRemoteDataSource.logout()).called(1);
        verify(mockAuthManager.logout()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockAuthManager);
      },
    );
  });
}
