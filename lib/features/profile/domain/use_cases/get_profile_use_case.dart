import '../../../../config/base_response/base_response.dart';
import '../../../auth/domain/entities/driver_entity.dart';
import '../../data/repository_impl/profile_repository_impl.dart';

class GetProfileUseCase {
  final ProfileRepositoryImpl profileRepositoryImpl ;
  GetProfileUseCase(this.profileRepositoryImpl);
  Future<BaseResponse<DriverEntity>> call()async {
    return await profileRepositoryImpl.getProfile();
  }
  }

