import 'package:dio/dio.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/services/media_service.dart';
import 'package:flowery_rider_app/features/profile/api/data_sources_impl/profile_remote_data_source_impl.dart';
import 'package:flowery_rider_app/features/profile/api/profile_api_client/profile_api_client.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/responses/edit_profile_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/upload_photo_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/vehicle_types_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient, MediaService])
void main() {
  late MockProfileApiClient mockApiClient;
  late MockMediaService mockMediaService;
  late ProfileRemoteDataSourceImpl dataSource;

  final tRequestModel = EditProfileRequestModel(
    firstName: 'ali',
    lastName: 'Tech2',
    email: 'midooabbas@gmail.com',
    phone: '+201070800978',
  );

  final tEditProfileResponse = EditProfileResponse(message: 'success');
  final tUploadPhotoResponse = UploadPhotoResponse(message: 'success');

  setUpAll(() {
    provideDummy<BaseResponse<EditProfileResponse>>(
      SuccessBaseResponse(data: EditProfileResponse()),
    );
    provideDummy<BaseResponse<UploadPhotoResponse>>(
      SuccessBaseResponse(data: UploadPhotoResponse()),
    );
    provideDummy<BaseResponse<VehicleTypesResponse>>(
      SuccessBaseResponse(data: VehicleTypesResponse()),
    );
  });

  setUp(() {
    mockApiClient = MockProfileApiClient();
    mockMediaService = MockMediaService();
    dataSource = ProfileRemoteDataSourceImpl(mockApiClient, mockMediaService);
  });

  group('editProfile', () {
    test(
      'should return SuccessBaseResponse when api client editProfile call succeeds',
      () async {
        when(
          mockApiClient.editProfile(any),
        ).thenAnswer((_) async => tEditProfileResponse);

        final result = await dataSource.editProfile(
          requestModel: tRequestModel,
        );

        expect(result, isA<SuccessBaseResponse<EditProfileResponse>>());
        expect(
          (result as SuccessBaseResponse<EditProfileResponse>).data,
          tEditProfileResponse,
        );
        verify(mockApiClient.editProfile(any)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return ErrorBaseResponse when api client editProfile call fails',
      () async {
        final exception = Exception('Server Error');
        when(mockApiClient.editProfile(any)).thenThrow(exception);

        final result = await dataSource.editProfile(
          requestModel: tRequestModel,
        );

        expect(result, isA<ErrorBaseResponse<EditProfileResponse>>());
        verify(mockApiClient.editProfile(any)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );
  });

  group('uploadPhoto', () {
    test('should return ErrorBaseResponse when file does not exist', () async {
      const filePath = '/non/existent/path/photo.jpg';

      when(
        mockMediaService.createMultipartFile(any),
      ).thenThrow(Exception('File not found'));

      final result = await dataSource.uploadPhoto(filePath: filePath);

      expect(result, isA<ErrorBaseResponse<UploadPhotoResponse>>());
      verifyZeroInteractions(mockApiClient);
    });

    test(
      'should return SuccessBaseResponse when api client uploadPhoto call succeeds',
      () async {
        when(
          mockApiClient.uploadPhoto(any),
        ).thenAnswer((_) async => tUploadPhotoResponse);

        final multipartFile = MultipartFile.fromBytes([
          1,
          2,
          3,
        ], filename: 'photo.jpg');

        when(
          mockMediaService.createMultipartFile(any),
        ).thenAnswer((_) async => multipartFile);

        final result = await dataSource.uploadPhoto(filePath: 'photo.jpg');

        expect(result, isA<SuccessBaseResponse<UploadPhotoResponse>>());
      },
    );

    test(
      'should return ErrorBaseResponse when api client uploadPhoto call fails',
      () async {
        when(
          mockApiClient.uploadPhoto(any),
        ).thenThrow(Exception('Upload failed'));

        when(
          mockMediaService.createMultipartFile(any),
        ).thenAnswer((_) async => MultipartFile.fromBytes([1], filename: 'photo.jpg'));

        final result = await dataSource.uploadPhoto(
          filePath: '/fake/photo.jpg',
        );

        expect(result, isA<ErrorBaseResponse<UploadPhotoResponse>>());
      },
    );
  });

  group('getVehicleTypes', () {
    test(
      'should return SuccessBaseResponse when api client getVehicleTypes call succeeds',
      () async {
        final tResponse = VehicleTypesResponse(
          message: 'success',
          vehicles: [],
        );
        when(
          mockApiClient.getVehicleTypes(any, any),
        ).thenAnswer((_) async => tResponse);

        final result = await dataSource.getVehicleTypes(page: 1, limit: 40);

        expect(result, isA<SuccessBaseResponse<VehicleTypesResponse>>());
        expect(
          (result as SuccessBaseResponse<VehicleTypesResponse>).data,
          tResponse,
        );
        verify(mockApiClient.getVehicleTypes(any, any)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return ErrorBaseResponse when api client getVehicleTypes call fails',
      () async {
        when(
          mockApiClient.getVehicleTypes(any, any),
        ).thenThrow(Exception('Network error'));

        final result = await dataSource.getVehicleTypes(page: 1, limit: 40);

        expect(result, isA<ErrorBaseResponse<VehicleTypesResponse>>());
        verify(mockApiClient.getVehicleTypes(any, any)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );
  });
}
