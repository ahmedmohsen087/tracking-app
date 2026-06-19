import 'package:flowery_rider_app/features/apply/domain/entities/driver_entity.dart';

class ApplyResponseEntity {
  final String? message;
  final DriverEntity? driver;
  final String? token;

  const ApplyResponseEntity({this.message, this.driver, this.token});
}
