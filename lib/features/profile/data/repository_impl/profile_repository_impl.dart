import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_vehicle_info_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/responses/edit_profile_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/upload_photo_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/vehicle_types_response.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_info_updated_entity.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_types_response_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository_contract/profile_repository_contract.dart';
import '../data_sources_contract/profile_remote_data_source_contract.dart';

@Injectable(as: ProfileRepositoryContract)
class ProfileRepositoryImpl implements ProfileRepositoryContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<EditProfileResponseEntity>> editProfile({
    required EditProfileRequestModel requestModel,
  }) async {
    final response = await _remoteDataSource.editProfile(
      requestModel: requestModel,
    );

    switch (response) {
      case SuccessBaseResponse<EditProfileResponse>():
        final driver = response.data.driver?.toEntity();
        final entity = EditProfileResponseEntity(
          message: response.data.message,
          driver: driver,
        );
        return SuccessBaseResponse<EditProfileResponseEntity>(data: entity);
      case ErrorBaseResponse<EditProfileResponse>():
        return ErrorBaseResponse<EditProfileResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<String>> uploadPhoto({required String filePath}) async {
    final response = await _remoteDataSource.uploadPhoto(filePath: filePath);

    switch (response) {
      case SuccessBaseResponse<UploadPhotoResponse>():
        return SuccessBaseResponse<String>(
          data: response.data.message ?? '',
        );
      case ErrorBaseResponse<UploadPhotoResponse>():
        return ErrorBaseResponse<String>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<VehicleTypesResponseEntity>> getVehicleTypes({
    required int page,
    required int limit,
  }) async {
    final response = await _remoteDataSource.getVehicleTypes(
      page: page,
      limit: limit,
    );

    switch (response) {
      case SuccessBaseResponse<VehicleTypesResponse>():
        final vehicles =
            response.data.vehicles?.map((m) => m.toEntity()).toList() ?? [];
        final entity = VehicleTypesResponseEntity(
          message: response.data.message,
          vehicles: vehicles,
        );
        return SuccessBaseResponse<VehicleTypesResponseEntity>(data: entity);
      case ErrorBaseResponse<VehicleTypesResponse>():
        return ErrorBaseResponse<VehicleTypesResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<VehicleInfoUpdatedEntity>> editVehicleInfo({
    required EditVehicleInfoRequestModel requestModel,
  }) async {
    final response = await _remoteDataSource.editVehicleInfo(
      requestModel: requestModel,
    );

    switch (response) {
      case SuccessBaseResponse<String>():
        final entity = VehicleInfoUpdatedEntity(
          vehicleTypeId: requestModel.vehicleTypeId,
          vehicleNumber: requestModel.vehicleNumber,
          vehicleLicenseFileName: requestModel.vehicleLicenseFilePath
              .split('/')
              .last,
        );
        return SuccessBaseResponse<VehicleInfoUpdatedEntity>(data: entity);
      case ErrorBaseResponse<String>():
        return ErrorBaseResponse<VehicleInfoUpdatedEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }
}

