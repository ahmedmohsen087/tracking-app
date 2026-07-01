import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/data/data_sources_contract/auth_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/auth/data/models/auth_response_model.dart';
import 'package:flowery_rider_app/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSourceContract, AuthManager])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSourceContract mockDataSource;
  late MockAuthManager mockAuthManager;

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

  group('logout', () {
    test(
      'should return SuccessBaseResponse when remote datasource logout succeeds',
      () async {

        final response = AuthResponseModel(message: 'Success', token: 'token');
        when(
          mockDataSource.logout(),
        ).thenAnswer((_) async => SuccessBaseResponse(data: response));

        final result = await repository.logout();

        expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
        expect(
          (result as SuccessBaseResponse<AuthResponseEntity>).data.message,
          'Success',
        );
        verify(mockDataSource.logout()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'should return ErrorBaseResponse when remote datasource logout fails',
      () async {

        when(
          mockDataSource.logout(),
        ).thenAnswer((_) async => ErrorBaseResponse(errorMessage: 'Remote Fail'));

        final result = await repository.logout();

        expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
        expect(
          (result as ErrorBaseResponse<AuthResponseEntity>).errorMessage,
          'Remote Fail',
        );
        verify(mockDataSource.logout()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );
  });
}
