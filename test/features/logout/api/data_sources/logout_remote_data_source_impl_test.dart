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

  setUp(() {
    mockApiClient = MockLogoutApiClient();
    datasource = LogoutRemoteDataSourceImpl(mockApiClient);
  });

  group('logout', () {
    test('should complete successfully when api call succeeds', () async {
      // Arrange
      when(mockApiClient.logout()).thenAnswer((_) async {});

      // Act & Assert
      expect(datasource.logout(), completes);

      verify(mockApiClient.logout()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('should throw an exception when api call fails', () async {
      // Arrange
      final exception = Exception('Server Error');
      when(mockApiClient.logout()).thenThrow(exception);

      expect(() => datasource.logout(), throwsA(isA<Exception>()));

      verify(mockApiClient.logout()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
