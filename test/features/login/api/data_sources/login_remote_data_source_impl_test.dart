import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:flowery_rider_app/core/values/api_parameters.dart';
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

  final tRequestMap = {
    ApiParameters.email: tEmail,
    ApiParameters.password: tPassword,
  };

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
      'should return AuthResponse when api client login call succeeds',
      () async {
        // Arrange
        when(
          mockApiClient.login(tRequestMap),
        ).thenAnswer((_) async => tAuthResponse);

        // Act
        final result = await datasource.login(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, tAuthResponse);
        verify(mockApiClient.login(tRequestMap)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should throw an exception when api client login call fails',
      () async {
        // Arrange
        final exception = Exception('Invalid Credentials');
        when(mockApiClient.login(tRequestMap)).thenThrow(exception);

        // Act & Assert
        expect(
          () => datasource.login(email: tEmail, password: tPassword),
          throwsA(isA<Exception>()),
        );

        verify(mockApiClient.login(tRequestMap)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );
  });
}
