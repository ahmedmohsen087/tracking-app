import 'package:dio/dio.dart';
import 'package:flowery_rider_app/features/forget_password/data/models/forget_password_model.dart';
import 'package:flowery_rider_app/features/forget_password/data/models/reset_password_model.dart';
import 'package:flowery_rider_app/features/forget_password/data/models/verify_otp_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/values/endpoints.dart';

part 'forget_password_api.g.dart';

@injectable
@RestApi()
abstract class ForgetPasswordApi {
  @factoryMethod
  factory ForgetPasswordApi(Dio dio) = _ForgetPasswordApi;

  @POST(Endpoints.forgetPassword)
  Future<void> forgetPassword(@Body() ForgetPasswordModel body);

  @POST(Endpoints.verifyOtp)
  Future<void> verifyOtp(@Body() VerifyOtpModel body);

  @PUT(Endpoints.resetPassword)
  Future<void> resetPassword(@Body() ResetPasswordModel body);
}
