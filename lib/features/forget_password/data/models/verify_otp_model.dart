import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/verify_otp_entity.dart';

part 'verify_otp_model.g.dart';

@JsonSerializable()
class VerifyOtpModel extends VerifyOtpEntity {
  const VerifyOtpModel({
    required super.email,
    required super.otp,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$VerifyOtpModelToJson(this);

  factory VerifyOtpModel.fromEntity(VerifyOtpEntity entity) {
    return VerifyOtpModel(
      email: entity.email,
      otp: entity.otp,
    );
  }
}