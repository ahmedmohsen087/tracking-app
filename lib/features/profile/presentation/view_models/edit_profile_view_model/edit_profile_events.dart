import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';

sealed class EditProfileEvents {}

class EditProfileSubmitEvent extends EditProfileEvents {
  final EditProfileRequestModel requestModel;

  EditProfileSubmitEvent({required this.requestModel});
}

class UploadPhotoEvent extends EditProfileEvents {
  final String filePath;

  UploadPhotoEvent({required this.filePath});
}
