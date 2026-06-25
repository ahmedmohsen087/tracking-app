import 'package:equatable/equatable.dart';
import 'package:flowery_rider_app/config/base_state/base_state.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';

class EditProfileState extends Equatable {
  final BaseState<EditProfileResponseEntity> editProfileState;
  final BaseState<String> uploadPhotoState;

  const EditProfileState({
    this.editProfileState = const BaseState(),
    this.uploadPhotoState = const BaseState(),
  });

  EditProfileState copyWith({
    BaseState<EditProfileResponseEntity>? editProfileState,
    BaseState<String>? uploadPhotoState,
  }) {
    return EditProfileState(
      editProfileState: editProfileState ?? this.editProfileState,
      uploadPhotoState: uploadPhotoState ?? this.uploadPhotoState,
    );
  }

  @override
  List<Object?> get props => [editProfileState, uploadPhotoState];
}
