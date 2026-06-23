import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/driver_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/get_profile_view_model/get_profile_event.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/get_profile_view_model/get_profile_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/get_profile_view_model/get_profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_profile_view_model_test.mocks.dart';

const tDriverEntity = DriverEntity(
  id: 'dummy_id',
  firstName: 'John',
  lastName: 'Doe',
  email: 'john.doe@example.com',
  phone: '1234567890',
  photo: 'https://placeholder.com/photo.jpg',
  vehicleType: 'Car',
  vehicleNumber: '123-ABC',
);

@GenerateMocks([GetProfileUseCase])
void main() {
  late MockGetProfileUseCase mockGetProfileUseCase;
  late GetProfileViewModel sut;

  setUpAll(() {
    provideDummy<BaseResponse<DriverEntity>>(
      SuccessBaseResponse<DriverEntity>(data: tDriverEntity),
    );
  });

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
    sut = GetProfileViewModel(mockGetProfileUseCase);
  });

  tearDown(() => sut.close());

  group('Initial State', () {
    test('should emit default GetProfileState on creation', () {
      expect(sut.state, const GetProfileState());
      expect(sut.state.getProfileState, isA<BaseState<DriverEntity>>());
      expect(sut.state.getProfileState.isLoading, isFalse);
    });
  });

  group('GetProfileViewModel Tests', () {
    blocTest<GetProfileViewModel, GetProfileState>(
      'emits loading then success state when getProfile succeeds',
      build: () {
        when(mockGetProfileUseCase.call()).thenAnswer(
          (_) async => SuccessBaseResponse<DriverEntity>(data: tDriverEntity),
        );
        return sut;
      },
      act: (viewModel) => viewModel.doEvent(const LoadProfileDataEvent()),
      expect: () => [
        isA<GetProfileState>().having(
          (s) => s.getProfileState.isLoading,
          'getProfileState.isLoading',
          isTrue,
        ),
        isA<GetProfileState>()
            .having(
              (s) => s.getProfileState.isLoading,
              'getProfileState.isLoading',
              isFalse,
            )
            .having(
              (s) => s.getProfileState.data,
              'getProfileState.data',
              tDriverEntity,
            ),
      ],
      verify: (_) {
        verify(mockGetProfileUseCase.call()).called(1);
      },
    );

    blocTest<GetProfileViewModel, GetProfileState>(
      'emits loading then error state when getProfile fails',
      build: () {
        when(mockGetProfileUseCase.call()).thenAnswer(
          (_) async => ErrorBaseResponse<DriverEntity>(
            errorMessage: 'Failed to fetch profile',
          ),
        );
        return sut;
      },
      act: (viewModel) => viewModel.doEvent(const LoadProfileDataEvent()),
      expect: () => [
        isA<GetProfileState>().having(
          (s) => s.getProfileState.isLoading,
          'getProfileState.isLoading',
          isTrue,
        ),
        isA<GetProfileState>()
            .having(
              (s) => s.getProfileState.isLoading,
              'getProfileState.isLoading',
              isFalse,
            )
            .having(
              (s) => s.getProfileState.msg,
              'getProfileState.msg',
              'Failed to fetch profile',
            ),
      ],
      verify: (_) {
        verify(mockGetProfileUseCase.call()).called(1);
      },
    );
  });
}
