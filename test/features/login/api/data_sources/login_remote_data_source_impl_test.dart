import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/api/auth_api_client/auth_api_client.dart';
import 'package:flowery_rider_app/features/auth/api/data_sources_impl/auth_remote_data_source_impl.dart';
import 'package:flowery_rider_app/features/auth/data/models/auth_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApiClient])
void main() {
  late MockAuthApiClient mockApiClient;
  late AuthRemoteDataSourceImpl datasource;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  final tAuthResponse = AuthResponseModel(
    token: 'mocked_jwt_token_for_testing',
    message: 'Success',
  );

  setUpAll(() {
    provideDummy<BaseResponse<AuthResponseModel>>(
      SuccessBaseResponse(data: AuthResponseModel()),
    );
  });

  setUp(() {
    mockApiClient = MockAuthApiClient();
    datasource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  group('login', () {
    test(
      'should return SuccessBaseResponse when api client login call succeeds',
      () async {

        when(mockApiClient.login(any)).thenAnswer((_) async => tAuthResponse);

        final result = await datasource.login(
          email: tEmail,
          password: tPassword,
        );

        expect(result, isA<SuccessBaseResponse<AuthResponseModel>>());
        expect(
          (result as SuccessBaseResponse<AuthResponseModel>).data,
          tAuthResponse,
        );
        verify(mockApiClient.login(any)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return ErrorBaseResponse when api client login call fails',
      () async {

        final exception = Exception('Invalid Credentials');
        when(mockApiClient.login(any)).thenThrow(exception);

        final result = await datasource.login(
          email: tEmail,
          password: tPassword,
        );

        expect(result, isA<ErrorBaseResponse<AuthResponseModel>>());
        verify(mockApiClient.login(any)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );
  });
}
