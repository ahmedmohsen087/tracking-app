
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_vehicle_info_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_driver_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_info_updated_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_types_response_entity.dart';
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

  @override
  Future<BaseResponse<ProfileResponseEntity>> changePassword({required ProfileRequestModel requestModel}) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<EditProfileResponseEntity>> editProfile({required EditProfileRequestModel requestModel}) {
    // TODO: implement editProfile
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<VehicleInfoUpdatedEntity>> editVehicleInfo({required EditVehicleInfoRequestModel requestModel}) {
    // TODO: implement editVehicleInfo
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<VehicleTypesResponseEntity>> getVehicleTypes({required int page, required int limit}) {
    // TODO: implement getVehicleTypes
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<String>> uploadPhoto({required String filePath}) {
    // TODO: implement uploadPhoto
    throw UnimplementedError();
  }
}