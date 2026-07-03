import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_driver_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/get_profile_view_model/get_profile_event.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/get_profile_view_model/get_profile_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/get_profile_view_model/get_profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_profile_view_model_test.mocks.dart';

final tDriverEntity = ProfileDriverEntity(
  id: '1',
  country: 'Egypt',
  firstName: 'John',
  lastName: 'Doe',
  vehicleType: 'Car',
  vehicleNumber: 'ABC123',
  vehicleLicense: 'XYZ789',
  nid: '123456789',
  nidImg: 'https://example.com/nid.jpg',
  email: 'william.henry.moody@my-own-personal-domain.com',
  gender: 'Male',
  phone: '1234567890',
  photo: 'https://example.com/photo.jpg',
  role: 'Driver',
  createdAt: DateTime.now(),

);

@GenerateMocks([GetProfileUseCase])
void main() {
  late MockGetProfileUseCase mockGetProfileUseCase;
  late GetProfileViewModel sut;

  setUpAll(() {
    provideDummy<BaseResponse<ProfileDriverEntity>>(
      SuccessBaseResponse<ProfileDriverEntity>(data: tDriverEntity),
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
      expect(sut.state.getProfileState, isA<BaseState<ProfileDriverEntity>>());
      expect(sut.state.getProfileState.isLoading, isFalse);
    });
  });

  group('GetProfileViewModel Tests', () {
    blocTest<GetProfileViewModel, GetProfileState>(
      'emits loading then success state when getProfile succeeds',
      build: () {
        when(mockGetProfileUseCase.call()).thenAnswer(
          (_) async => SuccessBaseResponse<ProfileDriverEntity>(data: tDriverEntity ),
        );
        return sut;
      },
      act: (viewModel) => viewModel.doEvent(const RefreshProfileEvent()),
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
          (_) async => ErrorBaseResponse<ProfileDriverEntity>(
            errorMessage: 'Failed to fetch profile',
          ),
        );
        return sut;
      },
      act: (viewModel) => viewModel.doEvent(const RefreshProfileEvent()),
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
