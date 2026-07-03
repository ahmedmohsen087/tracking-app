import 'package:flowery_rider_app/features/auth/data/models/auth_response_model.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/features/auth/domain/entities/forget_password_entity.dart';
import 'driver_model_mapper.dart';

extension AuthResponseModelMapper on AuthResponseModel {
  AuthResponseEntity toEntity() {
    return AuthResponseEntity(
      message: message,
      token: token,
      driver: driver?.toEntity(),
    );
  }

  ForgetPasswordEntity toForgetPasswordEntity({
    ForgetPasswordRecoveryStep? step,
  }) {
    return ForgetPasswordEntity(
      message: message,
      info: info,
      status: status,
      forgetPasswordRecoveryStep: step,
    );
  }
}
