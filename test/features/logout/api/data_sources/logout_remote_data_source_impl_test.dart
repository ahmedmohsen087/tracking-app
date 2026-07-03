import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/api/auth_api_client/auth_api_client.dart';
import 'package:flowery_rider_app/features/auth/api/data_sources_impl/auth_remote_data_source_impl.dart';
import 'package:flowery_rider_app/features/auth/data/models/auth_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApiClient])
void main() {
  late MockAuthApiClient mockApiClient;
  late AuthRemoteDataSourceImpl datasource;

  final tAuthResponse = AuthResponseModel(message: 'Success', token: 'token');

  setUpAll(() {
    provideDummy<BaseResponse<AuthResponseModel>>(
      SuccessBaseResponse(data: AuthResponseModel()),
    );
  });

  setUp(() {
    mockApiClient = MockAuthApiClient();
    datasource = AuthRemoteDataSourceImpl(mockApiClient);
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
        expect(result, isA<SuccessBaseResponse<AuthResponseModel>>());
        expect(
          (result as SuccessBaseResponse<AuthResponseModel>).data,
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
        expect(result, isA<ErrorBaseResponse<AuthResponseModel>>());
        verify(mockApiClient.logout()).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );
  });
}
