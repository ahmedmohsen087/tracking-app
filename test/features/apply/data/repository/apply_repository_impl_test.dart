import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/auth/data/data_sources_contract/auth_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/auth/data/models/auth_response_model.dart';
import 'package:flowery_rider_app/features/auth/data/models/driver_model.dart';
import 'package:flowery_rider_app/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'apply_repository_impl_test.mocks.dart';

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

  final requestModel = ApplyRequestModel(
    country: 'Egypt',
    firstName: 'John',
    lastName: 'Doe',
    vehicleTypeId: '123',
    vehicleNumber: '1234',
    vehicleLicensePath: 'path/to/license.jpg',
    email: 'john@example.com',
    phone: '01000000000',
    nid: '12345678901234',
    nidImgPath: 'path/to/nid.jpg',
    password: 'password',
    confirmPassword: 'password',
    gender: 'male',
  );

  test(
    'should return SuccessBaseResponse of AuthResponseEntity on successful apply',
    () async {
      final response = AuthResponseModel(
        message: 'Success',
        token: 'token123',
        driver: Driver(id: 'id123', firstName: 'John', lastName: 'Doe'),
      );
      when(
        mockDataSource.apply(requestModel: anyNamed('requestModel')),
      ).thenAnswer((_) async => SuccessBaseResponse(data: response));

      final result = await repository.apply(requestModel: requestModel);

      expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
      final data = (result as SuccessBaseResponse<AuthResponseEntity>).data;
      expect(data.message, 'Success');
      expect(data.token, 'token123');
      expect(data.driver?.id, 'id123');
      verify(
        mockDataSource.apply(requestModel: anyNamed('requestModel')),
      ).called(1);
    },
  );

  test('should return ErrorBaseResponse on failed apply', () async {
    when(
      mockDataSource.apply(requestModel: anyNamed('requestModel')),
    ).thenAnswer(
      (_) async => ErrorBaseResponse(errorMessage: 'Error occurred'),
    );

    final result = await repository.apply(requestModel: requestModel);

    expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
    expect((result as ErrorBaseResponse).errorMessage, 'Error occurred');
  });
}
