import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadPhotoUseCase {
  final ProfileRepositoryContract _repository;

  UploadPhotoUseCase(this._repository);

  Future<BaseResponse<String>> execute({required String filePath}) =>
      _repository.uploadPhoto(filePath: filePath);
}
