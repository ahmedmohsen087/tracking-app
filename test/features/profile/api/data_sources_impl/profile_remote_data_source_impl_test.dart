import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/data_sources_impl/profile_remote_data_source_impl.dart';
import 'package:flowery_rider_app/features/profile/api/profile_api_client/profile_api_client.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/data/models/profile_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])
void main() {
  late ProfileRemoteDataSourceImpl sut;
  late MockProfileApiClient mockApiClient;

  const tPassword = 'Current123*';
  const tNewPassword = 'NewPass123*';
  const tErrorMessage = 'Something went wrong';

  final tResponseModel = ProfileResponseModel(
    message: 'ok',
    token: 'token_abc',
  );

  ProfileRequestModel;

  setUp(() {
    mockApiClient = MockProfileApiClient();
    sut = ProfileRemoteDataSourceImpl(mockApiClient);
  });

  group('ProfileRemoteDataSourceImpl — changePassword (success)', () {
    test(
      'Should call api client with correct ProfileRequestModel and return SuccessBaseResponse',
      () async {
        when(
          mockApiClient.changePassword(any),
        ).thenAnswer((_) async => tResponseModel);

        final result = await sut.changePassword(
          password: tPassword,
          newPassword: tNewPassword,
        );

        expect(result, isA<SuccessBaseResponse<ProfileResponseModel>>());
        final success = result as SuccessBaseResponse<ProfileResponseModel>;
        expect(success.data.token, tResponseModel.token);
        expect(success.data.message, tResponseModel.message);

        final captured =
            verify(mockApiClient.changePassword(captureAny)).captured.single
                as ProfileRequestModel;
        expect(captured.password, tPassword);
        expect(captured.newPassword, tNewPassword);
      },
    );

    test(
      'Should return SuccessBaseResponse wrapping the model returned by api client',
      () async {
        when(
          mockApiClient.changePassword(any),
        ).thenAnswer((_) async => tResponseModel);

        final result = await sut.changePassword(
          password: tPassword,
          newPassword: tNewPassword,
        );

        final data = (result as SuccessBaseResponse<ProfileResponseModel>).data;
        expect(data, tResponseModel);
      },
    );
  });

  group('ProfileRemoteDataSourceImpl — changePassword (failure)', () {
    test(
      'Should return ErrorBaseResponse when api client throws an exception',
      () async {
        when(
          mockApiClient.changePassword(any),
        ).thenThrow(Exception(tErrorMessage));

        final result = await sut.changePassword(
          password: tPassword,
          newPassword: tNewPassword,
        );

        expect(result, isA<ErrorBaseResponse<ProfileResponseModel>>());
      },
    );

    test(
      'Should call ErrorHandler and return its message when exception is thrown',
      () async {
        when(
          mockApiClient.changePassword(any),
        ).thenThrow(Exception(tErrorMessage));

        final result = await sut.changePassword(
          password: tPassword,
          newPassword: tNewPassword,
        );

        expect(result, isA<ErrorBaseResponse<ProfileResponseModel>>());
        final error = result as ErrorBaseResponse<ProfileResponseModel>;
        expect(error.errorMessage, isNotNull);
        expect(error.errorMessage, isA<String>());
      },
    );

    test(
      'Should never return SuccessBaseResponse when api client throws',
      () async {
        when(mockApiClient.changePassword(any)).thenThrow(Exception('error'));

        final result = await sut.changePassword(
          password: tPassword,
          newPassword: tNewPassword,
        );

        expect(result, isNot(isA<SuccessBaseResponse<ProfileResponseModel>>()));
      },
    );
  });
}
