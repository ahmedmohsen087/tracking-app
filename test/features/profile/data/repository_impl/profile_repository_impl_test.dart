import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/profile/data/models/profile_response_model.dart';
import 'package:flowery_rider_app/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repository_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSourceContract, AuthManager])
void main() {
  late ProfileRepositoryImpl sut;
  late MockProfileRemoteDataSourceContract mockDataSource;
  late MockAuthManager mockAuthManager;

  const tPassword = 'Current123*';
  const tNewPassword = 'NewPass123*';
  const tToken = 'token_abc';
  const tErrorMessage = 'Server error';

  final tRequest = ProfileRequestModel(
    password: tPassword,
    newPassword: tNewPassword,
  );

  final tModel = ProfileResponseModel(message: 'ok', token: tToken);

  final tModelNoToken = ProfileResponseModel(message: 'ok', token: null);

  setUpAll(() {
    provideDummy<BaseResponse<ProfileResponseModel>>(
      SuccessBaseResponse(data: tModel),
    );
  });

  setUp(() {
    mockDataSource = MockProfileRemoteDataSourceContract();
    mockAuthManager = MockAuthManager();
    sut = ProfileRepositoryImpl(mockDataSource, mockAuthManager);
  });

  group('ProfileRepositoryImpl — changePassword (success)', () {
    test(
      'Should call data source, save token, and return SuccessBaseResponse with mapped entity',
      () async {
        when(
          mockDataSource.changePassword(request: tRequest),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tModel));

        when(
          mockAuthManager.setAuthData(token: tToken),
        ).thenAnswer((_) async {});

        final result = await sut.changePassword(requestModel: tRequest);

        expect(result, isA<SuccessBaseResponse<ProfileResponseEntity>>());

        final success = result as SuccessBaseResponse<ProfileResponseEntity>;
        expect(success.data.token, tToken);
        expect(success.data.message, 'ok');

        verify(mockAuthManager.setAuthData(token: tToken)).called(1);
      },
    );

    test('Should NOT call setAuthData when response token is null', () async {
      when(
        mockDataSource.changePassword(request: tRequest),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tModelNoToken));

      final result = await sut.changePassword(requestModel: tRequest);

      expect(result, isA<SuccessBaseResponse<ProfileResponseEntity>>());

      verifyNever(mockAuthManager.setAuthData(token: anyNamed('token')));
    });

    test(
      'Should map ProfileResponseModel to ProfileResponseEntity correctly',
      () async {
        when(
          mockDataSource.changePassword(request: tRequest),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tModel));

        when(
          mockAuthManager.setAuthData(token: tToken),
        ).thenAnswer((_) async {});

        final result = await sut.changePassword(requestModel: tRequest);

        final entity =
            (result as SuccessBaseResponse<ProfileResponseEntity>).data;

        expect(entity, isA<ProfileResponseEntity>());
        expect(entity.token, tModel.token);
        expect(entity.message, tModel.message);
      },
    );
  });

  group('ProfileRepositoryImpl — changePassword (failure)', () {
    test(
      'Should return ErrorBaseResponse with same errorMessage when data source returns error',
      () async {
        when(mockDataSource.changePassword(request: tRequest)).thenAnswer(
          (_) async => ErrorBaseResponse<ProfileResponseModel>(
            errorMessage: tErrorMessage,
          ),
        );

        final result = await sut.changePassword(requestModel: tRequest);

        expect(result, isA<ErrorBaseResponse<ProfileResponseEntity>>());

        final error = result as ErrorBaseResponse<ProfileResponseEntity>;
        expect(error.errorMessage, tErrorMessage);

        verifyNever(mockAuthManager.setAuthData(token: anyNamed('token')));
      },
    );
  });
}
