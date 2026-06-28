import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/auth/auth_manager.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/change_password_usecase.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_events.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/change_password_view_model/change_password_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_view_model_test.mocks.dart';

@GenerateMocks([ChangePasswordUseCase, AuthManager])
void main() {
  late ChangePasswordViewModel sut;
  late MockChangePasswordUseCase mockUseCase;
  late MockAuthManager mockAuthManager;

  const tPassword = 'Current123*';
  const tNewPassword = 'NewPass123*';
  const tToken = 'new_token';
  const tErrorMessage = 'Wrong password';

  final tRequestModel = ProfileRequestModel(
    password: tPassword,
    newPassword: tNewPassword,
  );

  const tEntity = ProfileResponseEntity(token: tToken);
  const tEntityNoToken = ProfileResponseEntity(token: null);

  setUp(() {
    mockUseCase = MockChangePasswordUseCase();
    mockAuthManager = MockAuthManager();
    sut = ChangePasswordViewModel(mockUseCase);
  });

  tearDown(() => sut.close());

  group('ChangePasswordViewModel — EnableAutoValidateEvent', () {
    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'Should emit state with autoValidate=true',
      build: () => sut,
      act: (cubit) => cubit.doEvent(EnableAutoValidateEvent()),
      expect: () => [
        const ChangePasswordState(
          changePasswordState: BaseState(),
          autoValidate: true,
        ),
      ],
    );
  });

  group('ChangePasswordViewModel — ChangePasswordRequestEvent (success)', () {
    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'Should emit loading then success when use case returns success with token',
      build: () {
        when(
          mockUseCase.execute(requestModel: tRequestModel),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

        when(
          mockAuthManager.setAuthData(token: tToken),
        ).thenAnswer((_) async {});

        return sut;
      },
      act: (cubit) => cubit.doEvent(
        ChangePasswordRequestEvent(
          password: tPassword,
          newPassword: tNewPassword,
        ),
      ),
      expect: () => [
        ChangePasswordState(changePasswordState: BaseState.loading()),
        ChangePasswordState(changePasswordState: BaseState.success(tEntity)),
      ],
      verify: (_) {
        verify(mockUseCase.execute(requestModel: tRequestModel)).called(1);

        verify(mockAuthManager.setAuthData(token: tToken)).called(1);
      },
    );

    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'Should emit loading then success and skip setAuthData when token is null',
      build: () {
        when(
          mockUseCase.execute(requestModel: tRequestModel),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tEntityNoToken));

        return sut;
      },
      act: (cubit) => cubit.doEvent(
        ChangePasswordRequestEvent(
          password: tPassword,
          newPassword: tNewPassword,
        ),
      ),
      expect: () => [
        ChangePasswordState(changePasswordState: BaseState.loading()),
        ChangePasswordState(
          changePasswordState: BaseState.success(tEntityNoToken),
        ),
      ],
      verify: (_) {
        verify(mockUseCase.execute(requestModel: tRequestModel)).called(1);

        verifyNever(mockAuthManager.setAuthData(token: anyNamed('token')));
      },
    );
  });

  group('ChangePasswordViewModel — ChangePasswordRequestEvent (failure)', () {
    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'Should emit loading then error when use case returns error',
      build: () {
        when(mockUseCase.execute(requestModel: tRequestModel)).thenAnswer(
          (_) async => ErrorBaseResponse<ProfileResponseEntity>(
            errorMessage: tErrorMessage,
          ),
        );

        return sut;
      },
      act: (cubit) => cubit.doEvent(
        ChangePasswordRequestEvent(
          password: tPassword,
          newPassword: tNewPassword,
        ),
      ),
      expect: () => [
        ChangePasswordState(changePasswordState: BaseState.loading()),
        ChangePasswordState(
          changePasswordState: BaseState.error(tErrorMessage),
        ),
      ],
      verify: (_) {
        verify(mockUseCase.execute(requestModel: tRequestModel)).called(1);

        verifyNever(mockAuthManager.setAuthData(token: anyNamed('token')));
      },
    );
  });
}
