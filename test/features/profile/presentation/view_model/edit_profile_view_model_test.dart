import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_events.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_state.dart';
import 'package:flowery_rider_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_view_model_test.mocks.dart';

const tDriverEntity = DriverProfileEntity(
  id: 'dummy',
  firstName: 'ali',
  lastName: 'Tech2',
  email: 'midooabbas@gmail.com',
  phone: '+201070800978',
);

@GenerateMocks([EditProfileUseCase, UploadPhotoUseCase])
void main() {
  setUpAll(() {
    provideDummy<BaseResponse<EditProfileResponseEntity>>(
      SuccessBaseResponse<EditProfileResponseEntity>(
        data: const EditProfileResponseEntity(
          message: 'success',
          driver: tDriverEntity,
        ),
      ),
    );
    provideDummy<BaseResponse<String>>(
      SuccessBaseResponse<String>(data: 'success'),
    );
  });

  late MockEditProfileUseCase mockEditProfileUseCase;
  late MockUploadPhotoUseCase mockUploadPhotoUseCase;
  late EditProfileViewModel sut;

  final tRequestModel = EditProfileRequestModel(
    firstName: 'ali',
    lastName: 'Tech2',
    email: 'midooabbas@gmail.com',
    phone: '+201070800978',
  );

  final tResponseEntity = EditProfileResponseEntity(
    message: 'success',
    driver: tDriverEntity,
  );

  void stubEditSuccess() {
    when(
      mockEditProfileUseCase.execute(requestModel: anyNamed('requestModel')),
    ).thenAnswer(
      (_) async =>
          SuccessBaseResponse<EditProfileResponseEntity>(data: tResponseEntity),
    );
  }

  void stubEditError(String message) {
    when(
      mockEditProfileUseCase.execute(requestModel: anyNamed('requestModel')),
    ).thenAnswer(
      (_) async =>
          ErrorBaseResponse<EditProfileResponseEntity>(errorMessage: message),
    );
  }

  void stubUploadSuccess() {
    when(
      mockUploadPhotoUseCase.execute(filePath: anyNamed('filePath')),
    ).thenAnswer((_) async => SuccessBaseResponse<String>(data: 'success'));
  }

  void stubUploadError(String message) {
    when(
      mockUploadPhotoUseCase.execute(filePath: anyNamed('filePath')),
    ).thenAnswer((_) async => ErrorBaseResponse<String>(errorMessage: message));
  }

  setUp(() {
    mockEditProfileUseCase = MockEditProfileUseCase();
    mockUploadPhotoUseCase = MockUploadPhotoUseCase();
    sut = EditProfileViewModel(mockEditProfileUseCase, mockUploadPhotoUseCase);
  });

  tearDown(() => sut.close());

  group('Initial State', () {
    test('emits correct initial state on creation', () {
      expect(sut.state, const EditProfileState());
    });
  });

  group('EditProfileSubmitEvent', () {
    blocTest<EditProfileViewModel, EditProfileState>(
      'emits [loading, success] when edit profile use case succeeds',
      build: () {
        stubEditSuccess();
        return sut;
      },
      act: (vm) =>
          vm.doEvent(EditProfileSubmitEvent(requestModel: tRequestModel)),
      expect: () => [
        predicate<EditProfileState>((s) => s.editProfileState.isLoading),
        predicate<EditProfileState>(
          (s) => s.editProfileState.data == tResponseEntity,
        ),
      ],
      verify: (_) {
        verify(
          mockEditProfileUseCase.execute(
            requestModel: anyNamed('requestModel'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockEditProfileUseCase);
      },
    );

    blocTest<EditProfileViewModel, EditProfileState>(
      'emits [loading, error] when edit profile use case fails',
      build: () {
        stubEditError('Server Error');
        return sut;
      },
      act: (vm) =>
          vm.doEvent(EditProfileSubmitEvent(requestModel: tRequestModel)),
      expect: () => [
        predicate<EditProfileState>((s) => s.editProfileState.isLoading),
        predicate<EditProfileState>(
          (s) => s.editProfileState.msg == 'Server Error',
        ),
      ],
      verify: (_) {
        verify(
          mockEditProfileUseCase.execute(
            requestModel: anyNamed('requestModel'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockEditProfileUseCase);
      },
    );
  });

  group('UploadPhotoEvent', () {
    blocTest<EditProfileViewModel, EditProfileState>(
      'emits [loading, success] when upload photo use case succeeds',
      build: () {
        stubUploadSuccess();
        return sut;
      },
      act: (vm) => vm.doEvent(UploadPhotoEvent(filePath: '/path/photo.jpg')),
      expect: () => [
        predicate<EditProfileState>((s) => s.uploadPhotoState.isLoading),
        predicate<EditProfileState>(
          (s) => s.uploadPhotoState.data == 'success',
        ),
      ],
      verify: (_) {
        verify(
          mockUploadPhotoUseCase.execute(filePath: anyNamed('filePath')),
        ).called(1);
        verifyNoMoreInteractions(mockUploadPhotoUseCase);
      },
    );

    blocTest<EditProfileViewModel, EditProfileState>(
      'emits [loading, error] when upload photo use case fails',
      build: () {
        stubUploadError('Upload failed');
        return sut;
      },
      act: (vm) => vm.doEvent(UploadPhotoEvent(filePath: '/path/photo.jpg')),
      expect: () => [
        predicate<EditProfileState>((s) => s.uploadPhotoState.isLoading),
        predicate<EditProfileState>(
          (s) => s.uploadPhotoState.msg == 'Upload failed',
        ),
      ],
      verify: (_) {
        verify(
          mockUploadPhotoUseCase.execute(filePath: anyNamed('filePath')),
        ).called(1);
        verifyNoMoreInteractions(mockUploadPhotoUseCase);
      },
    );
  });
}
