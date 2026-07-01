import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/data/data_sources_contract/auth_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/auth/data/models/auth_response_model.dart';
import 'package:flowery_rider_app/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSourceContract, AuthManager])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSourceContract mockDataSource;
  late MockAuthManager mockAuthManager;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tToken = 'mocked_jwt_token';

  setUpAll(() {
    provideDummy<BaseResponse<AuthResponseModel>>(
      SuccessBaseResponse(data: AuthResponseModel()),
    );
  });

  setUp(() {
    mockDataSource = MockAuthRemoteDataSourceContract();
    mockAuthManager = MockAuthManager();
    repository = AuthRepositoryImpl(mockDataSource, mockAuthManager);
  });

  group('login', () {
    test(
      'should return SuccessBaseResponse and save auth data when login is successful',
      () async {

        final response = AuthResponseModel(message: 'Success', token: tToken);
        when(
          mockDataSource.login(email: anyNamed('email'), password: anyNamed('password')),
        ).thenAnswer((_) async => SuccessBaseResponse(data: response));

        when(
          mockAuthManager.setAuthData(token: anyNamed('token')),
        ).thenAnswer((_) async {});

        final result = await repository.login(email: tEmail, password: tPassword);

        expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
        expect(
          (result as SuccessBaseResponse<AuthResponseEntity>).data.token,
          tToken,
        );

        verify(
          mockDataSource.login(email: anyNamed('email'), password: anyNamed('password')),
        ).called(1);
        verify(mockAuthManager.setAuthData(token: tToken)).called(1);
        verifyNoMoreInteractions(mockDataSource);
        verifyNoMoreInteractions(mockAuthManager);
      },
    );

    test(
      'should return ErrorBaseResponse when remote data source login fails',
      () async {

        when(
          mockDataSource.login(email: anyNamed('email'), password: anyNamed('password')),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(errorMessage: 'Network Failure'),
        );

        final result = await repository.login(email: tEmail, password: tPassword);

        expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
        expect(
          (result as ErrorBaseResponse<AuthResponseEntity>).errorMessage,
          'Network Failure',
        );

        verify(
          mockDataSource.login(email: anyNamed('email'), password: anyNamed('password')),
        ).called(1);
        verifyNever(mockAuthManager.setAuthData(token: anyNamed('token')));
      },
    );
  });
}
