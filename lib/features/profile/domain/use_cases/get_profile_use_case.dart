import 'package:flowery_rider_app/features/profile/domain/entities/profile_driver_entity.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../repository_contract/profile_repository_contract.dart';

@injectable
class GetProfileUseCase {
  final ProfileRepositoryContract profileRepositoryContract ;
  GetProfileUseCase(this.profileRepositoryContract);
  Future<BaseResponse<ProfileDriverEntity>> call()async {
    return await profileRepositoryContract.getProfile();
  }
}

