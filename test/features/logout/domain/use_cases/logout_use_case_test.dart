import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:flowery_rider_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_use_case_test.mocks.dart';

@GenerateMocks([AuthRepositoryContract])
void main() {
  provideDummy<BaseResponse<AuthResponseEntity>>(
    SuccessBaseResponse<AuthResponseEntity>(
      data: const AuthResponseEntity(),
    ),
  );

  late MockAuthRepositoryContract mockRepository;
  late LogoutUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepositoryContract();
    useCase = LogoutUseCase(mockRepository);
  });

  test(
    'should return SuccessBaseResponse from repository when logout succeeds',
    () async {
      // Arrange
      final response = SuccessBaseResponse<AuthResponseEntity>(
        data: const AuthResponseEntity(),
      );
      when(mockRepository.logout()).thenAnswer((_) async => response);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, response);
      verify(mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return ErrorBaseResponse from repository when logout fails',
    () async {
      // Arrange
      final response = ErrorBaseResponse<AuthResponseEntity>(
        errorMessage: 'Logout Failed',
      );
      when(mockRepository.logout()).thenAnswer((_) async => response);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, response);
      verify(mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
