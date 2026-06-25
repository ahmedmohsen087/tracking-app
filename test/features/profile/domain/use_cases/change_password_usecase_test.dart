import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/change_password_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_usecase_test.mocks.dart';

@GenerateMocks([ProfileRepositoryContract])
void main() {
  late ChangePasswordUseCase sut;
  late MockProfileRepositoryContract mockRepository;

  const tPassword = 'Current123*';
  const tNewPassword = 'NewPass123*';
  const tErrorMessage = 'Server error';
  const tEntity = ProfileResponseEntity(token: 'token_abc');

  final tRequestModel = ProfileRequestModel(
    password: tPassword,
    newPassword: tNewPassword,
  );

  setUp(() {
    mockRepository = MockProfileRepositoryContract();
    sut = ChangePasswordUseCase(mockRepository);
  });

  group('ChangePasswordUseCase — execute', () {
    test(
      'Should delegate to repository.changePassword with correct params and return success',
      () async {
        when(
          mockRepository.changePassword(
            password: tPassword,
            newPassword: tNewPassword,
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

        final result = await sut.execute(requestModel: tRequestModel);

        expect(result, isA<SuccessBaseResponse<ProfileResponseEntity>>());
        final success = result as SuccessBaseResponse<ProfileResponseEntity>;
        expect(success.data, tEntity);

        verify(
          mockRepository.changePassword(
            password: tPassword,
            newPassword: tNewPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'Should return error response when repository returns error',
      () async {
        when(
          mockRepository.changePassword(
            password: tPassword,
            newPassword: tNewPassword,
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<ProfileResponseEntity>(
            errorMessage: tErrorMessage,
          ),
        );

        final result = await sut.execute(requestModel: tRequestModel);

        expect(result, isA<ErrorBaseResponse<ProfileResponseEntity>>());
        final error = result as ErrorBaseResponse<ProfileResponseEntity>;
        expect(error.errorMessage, tErrorMessage);
      },
    );

    test('Should call repository exactly once per execute call', () async {
      when(
        mockRepository.changePassword(
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

      await sut.execute(requestModel: tRequestModel);
      await sut.execute(requestModel: tRequestModel);

      verify(
        mockRepository.changePassword(
          password: tPassword,
          newPassword: tNewPassword,
        ),
      ).called(2);
    });
  });
}
