
import 'package:flowery_rider_app/features/profile/domain/entities/profile_driver_entity.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../../../core/values/app_strings.dart';
import '../../domain/repository_contract/profile_repository_contract.dart';
import '../data_sources_contract/profile_remote_data_source_contract.dart';
import '../models/get_profile_response.dart';

@Injectable(as: ProfileRepositoryContract)
class ProfileRepositoryImpl implements ProfileRepositoryContract {
  final ProfileRemoteDataSourceContract profileRemoteDataSourceContract;

  ProfileRepositoryImpl(
      this.profileRemoteDataSourceContract,
      );

  @override
  Future<BaseResponse<ProfileDriverEntity>> getProfile() async {
    final response = await profileRemoteDataSourceContract.getProfile();
    switch (response) {
      case SuccessBaseResponse<GetProfileResponse>():
        if (response.data.driver == null) {
          return ErrorBaseResponse<ProfileDriverEntity>(
            errorMessage: AppStrings.somethingWentWrong,
          );
        }
        return SuccessBaseResponse<ProfileDriverEntity>(
          data: response.data.driver!.toDomain(),
        );

      case ErrorBaseResponse<GetProfileResponse>():
        return ErrorBaseResponse<ProfileDriverEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }
}