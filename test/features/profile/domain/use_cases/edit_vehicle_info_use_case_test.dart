import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_vehicle_info_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_info_updated_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/edit_vehicle_info_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_vehicle_info_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepositoryContract])
void main() {
  late MockProfileRepositoryContract mockRepository;
  late EditVehicleInfoUseCase useCase;

  setUpAll(() {
    provideDummy<BaseResponse<VehicleInfoUpdatedEntity>>(
      SuccessBaseResponse(
        data: VehicleInfoUpdatedEntity(
          vehicleTypeId: '',
          vehicleNumber: '',
          vehicleLicenseFileName: '',
        ),
      ),
    );
  });

  setUp(() {
    mockRepository = MockProfileRepositoryContract();
    useCase = EditVehicleInfoUseCase(mockRepository);
  });

  group('EditVehicleInfoUseCase', () {
    test(
      'should return SuccessBaseResponse with mirrored vehicle data',
      () async {
        const requestModel = EditVehicleInfoRequestModel(
          vehicleTypeId: 'type-123',
          vehicleNumber: 'UP16DL0007',
          vehicleLicenseFilePath: '/storage/photos/license.jpg',
        );

        final tEntity = VehicleInfoUpdatedEntity(
          vehicleTypeId: 'type-123',
          vehicleNumber: 'UP16DL0007',
          vehicleLicenseFileName: 'license.jpg',
        );
        when(
          mockRepository.editVehicleInfo(
            requestModel: anyNamed('requestModel'),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

        final result = await useCase.execute(requestModel: requestModel);

        expect(result, isA<SuccessBaseResponse<VehicleInfoUpdatedEntity>>());
        final entity =
            (result as SuccessBaseResponse<VehicleInfoUpdatedEntity>).data;
        expect(entity.vehicleTypeId, 'type-123');
        expect(entity.vehicleNumber, 'UP16DL0007');
        expect(entity.vehicleLicenseFileName, 'license.jpg');
      },
    );

    test('should extract filename from full file path', () async {
      const requestModel = EditVehicleInfoRequestModel(
        vehicleTypeId: 'type-456',
        vehicleNumber: 'AB12CD3456',
        vehicleLicenseFilePath: '/deep/nested/path/my_license_photo.png',
      );

      final tEntity = VehicleInfoUpdatedEntity(
        vehicleTypeId: 'type-456',
        vehicleNumber: 'AB12CD3456',
        vehicleLicenseFileName: 'my_license_photo.png',
      );
      when(
        mockRepository.editVehicleInfo(requestModel: anyNamed('requestModel')),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

      final result = await useCase.execute(requestModel: requestModel);

      final entity =
          (result as SuccessBaseResponse<VehicleInfoUpdatedEntity>).data;
      expect(entity.vehicleLicenseFileName, 'my_license_photo.png');
    });

    test(
      'should return SuccessBaseResponse when filePath has no directory separator',
      () async {
        const requestModel = EditVehicleInfoRequestModel(
          vehicleTypeId: 'type-789',
          vehicleNumber: 'ZZ99ZZ9999',
          vehicleLicenseFilePath: 'license_file.jpg',
        );

        final tEntity = VehicleInfoUpdatedEntity(
          vehicleTypeId: 'type-789',
          vehicleNumber: 'ZZ99ZZ9999',
          vehicleLicenseFileName: 'license_file.jpg',
        );
        when(
          mockRepository.editVehicleInfo(
            requestModel: anyNamed('requestModel'),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

        final result = await useCase.execute(requestModel: requestModel);

        expect(result, isA<SuccessBaseResponse<VehicleInfoUpdatedEntity>>());
        final entity =
            (result as SuccessBaseResponse<VehicleInfoUpdatedEntity>).data;
        expect(entity.vehicleTypeId, 'type-789');
        expect(entity.vehicleNumber, 'ZZ99ZZ9999');
        expect(entity.vehicleLicenseFileName, 'license_file.jpg');
      },
    );
  });
}
