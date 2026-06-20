import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/apply/api/request_models/apply_request_model.dart';
import 'package:flowery_rider_app/features/apply/api/responses/apply_response.dart';
import 'package:flowery_rider_app/features/apply/data/data_sources/apply_remote_data_source.dart';
import 'package:flowery_rider_app/features/apply/domain/entities/apply_response_entity.dart';
import 'package:flowery_rider_app/features/apply/domain/entities/driver_entity.dart';
import 'package:flowery_rider_app/features/apply/domain/repository/apply_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ApplyRepository)
class ApplyRepositoryImpl implements ApplyRepository {
  final ApplyRemoteDataSource _dataSource;

  ApplyRepositoryImpl(this._dataSource);

  @override
  Future<BaseResponse<ApplyResponseEntity>> apply({
    required ApplyRequestModel requestModel,
  }) async {
    final response = await _dataSource.apply(requestModel: requestModel);

    switch (response) {
      case SuccessBaseResponse<ApplyResponse>():
        final data = response.data;
        final driverResponse = data.driver;
        final DriverEntity? driverEntity = driverResponse == null
            ? null
            : DriverEntity(
                id: driverResponse.id,
                country: driverResponse.country,
                firstName: driverResponse.firstName,
                lastName: driverResponse.lastName,
                vehicleType: driverResponse.vehicleType,
                vehicleNumber: driverResponse.vehicleNumber,
                vehicleLicense: driverResponse.vehicleLicense,
                nid: driverResponse.nid,
                nidImg: driverResponse.nidImg,
                email: driverResponse.email,
                gender: driverResponse.gender,
                phone: driverResponse.phone,
                photo: driverResponse.photo,
                role: driverResponse.role,
                createdAt: driverResponse.createdAt,
              );

        return SuccessBaseResponse(
          data: ApplyResponseEntity(
            message: data.message,
            driver: driverEntity,
            token: data.token,
          ),
        );

      case ErrorBaseResponse<ApplyResponse>():
        return ErrorBaseResponse(
          errorMessage: response.errorMessage,
        );
    }
  }
}
