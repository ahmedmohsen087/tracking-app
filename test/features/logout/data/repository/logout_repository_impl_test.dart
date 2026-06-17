import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/logout/data/data_sources/logout_remote_data_source.dart';
import 'package:flowery_rider_app/features/logout/data/repository/logout_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_repository_impl_test.mocks.dart';

@GenerateMocks([LogoutRemoteDataSource, AuthManager])
void main() {
  provideDummy<BaseResponse<void>>(SuccessBaseResponse<void>(data: null));

  late MockLogoutRemoteDataSource mockRemoteDataSource;
  late MockAuthManager mockAuthManager;
  late LogoutRepositoryImpl repository;

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
        when(mockRemoteDataSource.logout()).thenAnswer((_) async {});
        when(mockAuthManager.logout()).thenAnswer((_) async {});

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, isA<SuccessBaseResponse<void>>());

        verify(mockRemoteDataSource.logout()).called(1);
        verify(mockAuthManager.logout()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockAuthManager);
      },
    );

    test(
      'should return SuccessBaseResponse even when remote datasource throws exception but auth manager succeeds',
      () async {
        // Arrange - هنا بنحاكي إن الـ API ضرب بس الكاش اتمسح عادي
        when(mockRemoteDataSource.logout()).thenThrow(Exception('Remote Fail'));
        when(mockAuthManager.logout()).thenAnswer((_) async {});

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, isA<SuccessBaseResponse<void>>());

        verify(mockRemoteDataSource.logout()).called(1);
        verify(mockAuthManager.logout()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockAuthManager);
      },
    );

    test(
      'should return ErrorBaseResponse when auth manager throws exception',
      () async {
        // Arrange
        when(mockRemoteDataSource.logout()).thenAnswer((_) async {});
        when(mockAuthManager.logout()).thenThrow(Exception('Cache Clear Fail'));

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, isA<ErrorBaseResponse<void>>());

        verify(mockRemoteDataSource.logout()).called(1);
        verify(mockAuthManager.logout()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockAuthManager);
      },
    );
  });
}
