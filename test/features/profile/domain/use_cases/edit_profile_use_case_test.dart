import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_use_case_test.mocks.dart';

const tDriverProfileEntity = DriverProfileEntity(
  id: 'dummy',
  firstName: 'ali',
  lastName: 'Tech2',
  email: 'midooabbas@gmail.com',
  phone: '+201070800978',
);

@GenerateMocks([ProfileRepositoryContract])
void main() {
  provideDummy<BaseResponse<EditProfileResponseEntity>>(
    SuccessBaseResponse<EditProfileResponseEntity>(
      data: const EditProfileResponseEntity(
        message: 'success',
        driver: tDriverProfileEntity,
      ),
    ),
  );

  late MockProfileRepositoryContract mockRepository;
  late EditProfileUseCase useCase;

  final tRequestModel = EditProfileRequestModel(
    firstName: 'ali',
    lastName: 'Tech2',
    email: 'midooabbas@gmail.com',
    phone: '+201070800978',
  );

  final tResponseEntity = EditProfileResponseEntity(
    message: 'success',
    driver: tDriverProfileEntity,
  );

  setUp(() {
    mockRepository = MockProfileRepositoryContract();
    useCase = EditProfileUseCase(mockRepository);
  });

  group('EditProfileUseCase', () {
    test(
      'should forward params to repository and return SuccessBaseResponse on success',
      () async {
        final expectedResponse = SuccessBaseResponse<EditProfileResponseEntity>(
          data: tResponseEntity,
        );
        when(
          mockRepository.editProfile(requestModel: anyNamed('requestModel')),
        ).thenAnswer((_) async => expectedResponse);

        final result = await useCase.execute(requestModel: tRequestModel);

        expect(result, expectedResponse);
        verify(
          mockRepository.editProfile(requestModel: anyNamed('requestModel')),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should forward params to repository and return ErrorBaseResponse on failure',
      () async {
        final expectedResponse = ErrorBaseResponse<EditProfileResponseEntity>(
          errorMessage: 'Server Error',
        );
        when(
          mockRepository.editProfile(requestModel: anyNamed('requestModel')),
        ).thenAnswer((_) async => expectedResponse);

        final result = await useCase.execute(requestModel: tRequestModel);

        expect(result, expectedResponse);
        verify(
          mockRepository.editProfile(requestModel: anyNamed('requestModel')),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
