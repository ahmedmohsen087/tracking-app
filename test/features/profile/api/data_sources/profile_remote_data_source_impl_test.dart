import 'package:dio/dio.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/data_sources_impl/profile_remote_data_source_impl.dart';
import 'package:flowery_rider_app/features/profile/api/profile_api_client/profile_api_client.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/responses/edit_profile_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/upload_photo_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])
void main() {
  late MockProfileApiClient mockApiClient;
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
  });

  setUp(() {
    mockApiClient = MockProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(mockApiClient);
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

        final result = await dataSource.uploadPhoto(filePath: 'photo.jpg');

        expect(result, isA<ErrorBaseResponse<UploadPhotoResponse>>());
      },
    );

    test(
      'should return ErrorBaseResponse when api client uploadPhoto call fails',
      () async {
        when(
          mockApiClient.uploadPhoto(any),
        ).thenThrow(Exception('Upload failed'));

        final result = await dataSource.uploadPhoto(
          filePath: '/fake/photo.jpg',
        );

        expect(result, isA<ErrorBaseResponse<UploadPhotoResponse>>());
      },
    );
  });
}
