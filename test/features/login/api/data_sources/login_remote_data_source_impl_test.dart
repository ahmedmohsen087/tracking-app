import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:flowery_rider_app/features/login/api/data_sources/login_remote_data_source_impl.dart';
import 'package:flowery_rider_app/features/login/api/login_api_client/login_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([LoginApiClient])
void main() {
  late MockLoginApiClient mockApiClient;
  late LoginRemoteDataSourceImpl datasource;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  final tAuthResponse = AuthResponse(
    token: 'mocked_jwt_token_for_testing',
    message: 'Success',
  );

  setUp(() {
    mockApiClient = MockLoginApiClient();
    datasource = LoginRemoteDataSourceImpl(mockApiClient);
  });

  group('login', () {
    test(
      'should return SuccessBaseResponse when api client login call succeeds',
      () async {
        // Arrange
        when(mockApiClient.login(any)).thenAnswer((_) async => tAuthResponse);

        // Act
        final result = await datasource.login(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<AuthResponse>>());
        expect(
          (result as SuccessBaseResponse<AuthResponse>).data,
          tAuthResponse,
        );
        verify(mockApiClient.login(any)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return ErrorBaseResponse when api client login call fails',
      () async {
        // Arrange
        final exception = Exception('Invalid Credentials');
        when(mockApiClient.login(any)).thenThrow(exception);

        // Act
        final result = await datasource.login(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<AuthResponse>>());
        verify(mockApiClient.login(any)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );
  });
}
