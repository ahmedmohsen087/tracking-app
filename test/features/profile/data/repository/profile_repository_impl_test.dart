import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/responses/edit_profile_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/upload_photo_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/vehicle_types_response.dart';
import 'package:flowery_rider_app/features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart';
import 'package:flowery_rider_app/features/profile/data/models/driver_profile_model.dart';
import 'package:flowery_rider_app/features/profile/data/models/vehicle_type_model.dart';
import 'package:flowery_rider_app/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_types_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repository_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSourceContract])
void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileRemoteDataSourceContract mockDataSource;

  final tRequestModel = EditProfileRequestModel(
    firstName: 'ali',
    lastName: 'Tech2',
    email: 'midooabbas@gmail.com',
    phone: '+201070800978',
  );

  const tFilePath = '/path/to/photo.jpg';

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
    mockDataSource = MockProfileRemoteDataSourceContract();
    repository = ProfileRepositoryImpl(mockDataSource);
  });

  group('editProfile', () {
    test(
      'should return SuccessBaseResponse with mapped entity when data source succeeds',
      () async {
        final driverModel = DriverProfileModel(
          id: '123',
          firstName: 'ali',
          lastName: 'Tech2',
          email: 'midooabbas@gmail.com',
          phone: '+201070800978',
        );
        final response = EditProfileResponse(
          message: 'success',
          driver: driverModel,
        );

        when(
          mockDataSource.editProfile(requestModel: anyNamed('requestModel')),
        ).thenAnswer((_) async => SuccessBaseResponse(data: response));

        final result = await repository.editProfile(
          requestModel: tRequestModel,
        );

        expect(result, isA<SuccessBaseResponse<EditProfileResponseEntity>>());
        final entity =
            (result as SuccessBaseResponse<EditProfileResponseEntity>).data;
        expect(entity.message, 'success');
        expect(entity.driver?.firstName, 'ali');
        expect(entity.driver?.lastName, 'Tech2');

        verify(
          mockDataSource.editProfile(requestModel: anyNamed('requestModel')),
        ).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'should return ErrorBaseResponse when data source editProfile fails',
      () async {
        when(
          mockDataSource.editProfile(requestModel: anyNamed('requestModel')),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<EditProfileResponse>(
            errorMessage: 'Server Error',
          ),
        );

        final result = await repository.editProfile(
          requestModel: tRequestModel,
        );

        expect(result, isA<ErrorBaseResponse<EditProfileResponseEntity>>());
        expect(
          (result as ErrorBaseResponse<EditProfileResponseEntity>).errorMessage,
          'Server Error',
        );

        verify(
          mockDataSource.editProfile(requestModel: anyNamed('requestModel')),
        ).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );
  });

  group('uploadPhoto', () {
    test(
      'should return SuccessBaseResponse with message when data source upload succeeds',
      () async {
        when(
          mockDataSource.uploadPhoto(filePath: anyNamed('filePath')),
        ).thenAnswer(
          (_) async => SuccessBaseResponse(
            data: UploadPhotoResponse(message: 'success'),
          ),
        );

        final result = await repository.uploadPhoto(filePath: tFilePath);

        expect(result, isA<SuccessBaseResponse<String>>());
        expect((result as SuccessBaseResponse<String>).data, 'success');

        verify(
          mockDataSource.uploadPhoto(filePath: anyNamed('filePath')),
        ).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'should return ErrorBaseResponse when data source upload fails',
      () async {
        when(
          mockDataSource.uploadPhoto(filePath: anyNamed('filePath')),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<UploadPhotoResponse>(
            errorMessage: 'Upload failed',
          ),
        );

        final result = await repository.uploadPhoto(filePath: tFilePath);

        expect(result, isA<ErrorBaseResponse<String>>());
        expect(
          (result as ErrorBaseResponse<String>).errorMessage,
          'Upload failed',
        );

        verify(
          mockDataSource.uploadPhoto(filePath: anyNamed('filePath')),
        ).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );
  });

  group('getVehicleTypes', () {
    test(
      'should return SuccessBaseResponse with mapped entity when data source succeeds',
      () async {
        final vehicleModel = VehicleTypeModel(
          id: 'v-123',
          type: 'Car',
          image: 'https://example.com/car.jpg',
        );
        final rawResponse = VehicleTypesResponse(
          message: 'success',
          vehicles: [vehicleModel],
        );

        when(
          mockDataSource.getVehicleTypes(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: rawResponse));

        final result = await repository.getVehicleTypes(page: 1, limit: 40);

        expect(result, isA<SuccessBaseResponse<VehicleTypesResponseEntity>>());
        final entity =
            (result as SuccessBaseResponse<VehicleTypesResponseEntity>).data;
        expect(entity.message, 'success');
        expect(entity.vehicles.length, 1);
        expect(entity.vehicles.first.id, 'v-123');
        expect(entity.vehicles.first.type, 'Car');

        verify(
          mockDataSource.getVehicleTypes(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'should return ErrorBaseResponse when data source getVehicleTypes fails',
      () async {
        when(
          mockDataSource.getVehicleTypes(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<VehicleTypesResponse>(
            errorMessage: 'Network error',
          ),
        );

        final result = await repository.getVehicleTypes(page: 1, limit: 40);

        expect(result, isA<ErrorBaseResponse<VehicleTypesResponseEntity>>());
        expect(
          (result as ErrorBaseResponse<VehicleTypesResponseEntity>)
              .errorMessage,
          'Network error',
        );

        verify(
          mockDataSource.getVehicleTypes(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );
  });
}

