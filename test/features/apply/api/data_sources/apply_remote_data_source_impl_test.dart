import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/apply/api/apply_api_client/apply_api_client.dart';
import 'package:flowery_rider_app/features/apply/api/data_sources/apply_remote_data_source_impl.dart';
import 'package:flowery_rider_app/features/apply/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/apply/api/responses/apply_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'apply_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ApplyApiClient])
void main() {
  late ApplyRemoteDataSourceImpl dataSource;
  late MockApplyApiClient mockApiClient;
  late File licenseFile;
  late File nidFile;

  setUpAll(() {
    provideDummy<BaseResponse<ApplyResponse>>(
      SuccessBaseResponse(data: ApplyResponse()),
    );
  });

  setUp(() {
    mockApiClient = MockApplyApiClient();
    dataSource = ApplyRemoteDataSourceImpl(mockApiClient);

    licenseFile = File('test_license.jpg')..createSync();
    nidFile = File('test_nid.jpg')..createSync();
  });

  tearDown(() {
    if (licenseFile.existsSync()) licenseFile.deleteSync();
    if (nidFile.existsSync()) nidFile.deleteSync();
  });

  late ApplyRequestModel requestModel;

  setUp(() {
    requestModel = ApplyRequestModel(
      country: 'Egypt',
      firstName: 'John',
      lastName: 'Doe',
      vehicleTypeId: '123',
      vehicleNumber: '1234',
      vehicleLicensePath: 'test_license.jpg',
      email: 'john@example.com',
      phone: '01000000000',
      nid: '12345678901234',
      nidImgPath: 'test_nid.jpg',
      password: 'password',
      confirmPassword: 'password',
      gender: 'male',
    );
  });

  test(
    'should return SuccessBaseResponse when API call is successful',
    () async {
      final response = ApplyResponse();
      when(mockApiClient.applyAsDriver(any)).thenAnswer((_) async => response);

      final result = await dataSource.apply(requestModel: requestModel);

      expect(result, isA<SuccessBaseResponse<ApplyResponse>>());
      verify(mockApiClient.applyAsDriver(any)).called(1);
    },
  );

  test('should return ErrorBaseResponse when API call fails', () async {
    when(mockApiClient.applyAsDriver(any)).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Server error'},
        ),
      ),
    );

    final result = await dataSource.apply(requestModel: requestModel);

    expect(result, isA<ErrorBaseResponse<ApplyResponse>>());
    expect((result as ErrorBaseResponse).errorMessage, 'Server error');
  });
}
