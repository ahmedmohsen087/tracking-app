import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/apply/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/apply/api/responses/apply_response.dart';
import 'package:flowery_rider_app/features/apply/data/data_sources/apply_remote_data_source.dart';
import 'package:flowery_rider_app/features/apply/data/repository/apply_repository_impl.dart';
import 'package:flowery_rider_app/features/apply/domain/entities/apply_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'apply_repository_impl_test.mocks.dart';

@GenerateMocks([ApplyRemoteDataSource])
void main() {
  late ApplyRepositoryImpl repository;
  late MockApplyRemoteDataSource mockDataSource;

  setUpAll(() {
    provideDummy<BaseResponse<ApplyResponse>>(
      SuccessBaseResponse(data: ApplyResponse()),
    );
  });

  setUp(() {
    mockDataSource = MockApplyRemoteDataSource();
    repository = ApplyRepositoryImpl(mockDataSource);
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
    'should return SuccessBaseResponse of ApplyResponseEntity on successful apply',
    () async {
      final response = ApplyResponse(
        message: 'Success',
        token: 'token123',
        driver: DriverResponse(id: 'id123', firstName: 'John', lastName: 'Doe'),
      );
      when(
        mockDataSource.apply(requestModel: anyNamed('requestModel')),
      ).thenAnswer((_) async => SuccessBaseResponse(data: response));

      final result = await repository.apply(requestModel: requestModel);

      expect(result, isA<SuccessBaseResponse<ApplyResponseEntity>>());
      final data = (result as SuccessBaseResponse<ApplyResponseEntity>).data;
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

    expect(result, isA<ErrorBaseResponse<ApplyResponseEntity>>());
    expect((result as ErrorBaseResponse).errorMessage, 'Error occurred');
  });
}
