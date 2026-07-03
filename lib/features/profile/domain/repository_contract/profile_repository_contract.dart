import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_vehicle_info_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_info_updated_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_types_response_entity.dart';

import '../entities/profile_driver_entity.dart';

abstract interface class ProfileRepositoryContract {
  Future<BaseResponse<EditProfileResponseEntity>> editProfile({
    required EditProfileRequestModel requestModel,
  });
  Future<BaseResponse<ProfileDriverEntity>> getProfile();


  Future<BaseResponse<String>> uploadPhoto({required String filePath});

  Future<BaseResponse<VehicleTypesResponseEntity>> getVehicleTypes({
    required int page,
    required int limit,
  });

  Future<BaseResponse<VehicleInfoUpdatedEntity>> editVehicleInfo({
    required EditVehicleInfoRequestModel requestModel,
  });

  Future<BaseResponse<ProfileResponseEntity>> changePassword({
    required ProfileRequestModel requestModel,
  });
}


