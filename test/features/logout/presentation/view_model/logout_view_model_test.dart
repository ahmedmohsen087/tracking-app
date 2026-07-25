import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/logout_view_model/logout_events.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/logout_view_model/logout_state.dart';
import 'package:flowery_rider_app/features/auth/presentation/view_models/logout_view_model/logout_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_view_model_test.mocks.dart';

@GenerateMocks([LogoutUseCase])
void main() {
  setUpAll(() {
    provideDummy<BaseResponse<void>>(SuccessBaseResponse<void>(data: null));
  });

  late MockLogoutUseCase mockLogoutUseCase;
  late LogoutViewModel sut;

  void stubLogoutSuccess() {
    when(
      mockLogoutUseCase.execute(),
    ).thenAnswer((_) async => SuccessBaseResponse<void>(data: null));
  }

  void stubLogoutError(String message) {
    when(
      mockLogoutUseCase.execute(),
    ).thenAnswer((_) async => ErrorBaseResponse<void>(errorMessage: message));
  }

  setUp(() {
    mockLogoutUseCase = MockLogoutUseCase();
    sut = LogoutViewModel(mockLogoutUseCase);
  });

  tearDown(() => sut.close());

  group('LogoutRequestEvent', () {
    blocTest<LogoutViewModel, LogoutState>(
      'emits [loading, success] states when logout succeeds',
      build: () {
        stubLogoutSuccess();
        return sut;
      },
      act: (vm) => vm.doEvent(LogoutRequestEvent()),
      expect: () => [
        isA<LogoutState>().having(
          (s) => s.logoutState.isLoading,
          'logoutState.isLoading',
          isTrue,
        ),
        isA<LogoutState>()
            .having(
              (s) => s.logoutState.isLoading,
              'logoutState.isLoading',
              isFalse,
            )
            .having(
              (s) => s.logoutState.data,
              'logoutState.data',
              isNull,
            ),
      ],
      verify: (_) {
        verify(mockLogoutUseCase.execute()).called(1);
        verifyNoMoreInteractions(mockLogoutUseCase);
      },
    );

    blocTest<LogoutViewModel, LogoutState>(
      'emits [loading, error] states when logout fails',
      build: () {
        stubLogoutError('Something went wrong');
        return sut;
      },
      act: (vm) => vm.doEvent(LogoutRequestEvent()),
      expect: () => [
        isA<LogoutState>().having(
          (s) => s.logoutState.isLoading,
          'logoutState.isLoading',
          isTrue,
        ),
        isA<LogoutState>()
            .having(
              (s) => s.logoutState.isLoading,
              'logoutState.isLoading',
              isFalse,
            )
            .having(
              (s) => s.logoutState.msg,
              'logoutState.msg',
              'Something went wrong',
            ),
      ],
      verify: (_) {
        verify(mockLogoutUseCase.execute()).called(1);
        verifyNoMoreInteractions(mockLogoutUseCase);
      },
    );
  });
}
