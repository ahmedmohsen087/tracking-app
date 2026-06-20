import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:flowery_rider_app/features/logout/domain/repository/logout_repository.dart';
import 'package:flowery_rider_app/features/logout/domain/use_cases/logout_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_use_case_test.mocks.dart';

@GenerateMocks([LogoutRepository])
void main() {
  provideDummy<BaseResponse<AuthResponse>>(
    SuccessBaseResponse<AuthResponse>(data: AuthResponse()),
  );

  late MockLogoutRepository mockRepository;
  late LogoutUseCase useCase;

  setUp(() {
    mockRepository = MockLogoutRepository();
    useCase = LogoutUseCase(mockRepository);
  });

  test(
    'should return SuccessBaseResponse from repository when logout succeeds',
    () async {
      // Arrange
      final response = SuccessBaseResponse<AuthResponse>(
        data: AuthResponse(),
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
      final response = ErrorBaseResponse<AuthResponse>(
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
