import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/core/models/auth_response.dart';
import 'package:flowery_rider_app/features/logout/api/data_sources/logout_remote_data_source_impl.dart';
import 'package:flowery_rider_app/features/logout/api/logout_api_client/logout_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([LogoutApiClient])
void main() {
  late MockLogoutApiClient mockApiClient;
  late LogoutRemoteDataSourceImpl datasource;

  final tAuthResponse = AuthResponse(message: 'Success', token: 'token');

  setUp(() {
    mockApiClient = MockLogoutApiClient();
    datasource = LogoutRemoteDataSourceImpl(mockApiClient);
  });

  group('logout', () {
    test(
      'should return SuccessBaseResponse when api call succeeds',
      () async {
        // Arrange
        when(mockApiClient.logout()).thenAnswer((_) async => tAuthResponse);

        // Act
        final result = await datasource.logout();

        // Assert
        expect(result, isA<SuccessBaseResponse<AuthResponse>>());
        expect(
          (result as SuccessBaseResponse<AuthResponse>).data,
          tAuthResponse,
        );
        verify(mockApiClient.logout()).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return ErrorBaseResponse when api call fails',
      () async {
        // Arrange
        when(mockApiClient.logout()).thenThrow(Exception('Server Error'));

        // Act
        final result = await datasource.logout();

        // Assert
        expect(result, isA<ErrorBaseResponse<AuthResponse>>());
        verify(mockApiClient.logout()).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );
  });
}
