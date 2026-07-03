import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_types_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/get_vehicle_types_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_vehicle_types_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepositoryContract])
void main() {
  late GetVehicleTypesUseCase useCase;
  late MockProfileRepositoryContract mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<VehicleTypesResponseEntity>>(
      SuccessBaseResponse(
        data: const VehicleTypesResponseEntity(message: 'success'),
      ),
    );
  });

  setUp(() {
    mockRepository = MockProfileRepositoryContract();
    useCase = GetVehicleTypesUseCase(mockRepository);
  });

  group('GetVehicleTypesUseCase', () {
    test(
      'should delegate to repository and return SuccessBaseResponse on success',
      () async {
        final tResponse = VehicleTypesResponseEntity(
          message: 'success',
          vehicles: const [],
        );

        when(
          mockRepository.getVehicleTypes(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tResponse));

        final result = await useCase.execute(page: 1, limit: 40);

        expect(result, isA<SuccessBaseResponse<VehicleTypesResponseEntity>>());
        expect(
          (result as SuccessBaseResponse<VehicleTypesResponseEntity>).data,
          tResponse,
        );
        verify(
          mockRepository.getVehicleTypes(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should delegate to repository and return ErrorBaseResponse on failure',
      () async {
        when(
          mockRepository.getVehicleTypes(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(errorMessage: 'Network error'),
        );

        final result = await useCase.execute(page: 1, limit: 40);

        expect(result, isA<ErrorBaseResponse<VehicleTypesResponseEntity>>());
        expect(
          (result as ErrorBaseResponse<VehicleTypesResponseEntity>)
              .errorMessage,
          'Network error',
        );
        verify(
          mockRepository.getVehicleTypes(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
