import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:flowery_rider_app/features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'edit_profile_events.dart';
import 'edit_profile_state.dart';

@injectable
class EditProfileViewModel extends Cubit<EditProfileState> {
  final EditProfileUseCase _editProfileUseCase;
  final UploadPhotoUseCase _uploadPhotoUseCase;

  EditProfileViewModel(this._editProfileUseCase, this._uploadPhotoUseCase)
    : super(const EditProfileState());

  Future<void> doEvent(EditProfileEvents event) async {
    switch (event) {
      case EditProfileSubmitEvent():
        await _editProfile(event);
      case UploadPhotoEvent():
        await _uploadPhoto(event);
    }
  }

  Future<void> _editProfile(EditProfileSubmitEvent event) async {
    emit(state.copyWith(editProfileState: BaseState.loading()));
    final response = await _editProfileUseCase.execute(
      requestModel: event.requestModel,
    );
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse<EditProfileResponseEntity>():
        emit(
          state.copyWith(editProfileState: BaseState.success(response.data)),
        );
      case ErrorBaseResponse<EditProfileResponseEntity>():
        emit(
          state.copyWith(
            editProfileState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _uploadPhoto(UploadPhotoEvent event) async {
    emit(state.copyWith(uploadPhotoState: BaseState.loading()));
    final response = await _uploadPhotoUseCase.execute(
      filePath: event.filePath,
    );
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse<String>():
        emit(
          state.copyWith(uploadPhotoState: BaseState.success(response.data)),
        );
      case ErrorBaseResponse<String>():
        emit(
          state.copyWith(
            uploadPhotoState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }
}
