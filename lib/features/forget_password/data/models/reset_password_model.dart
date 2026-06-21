import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/reset_password_entity.dart';

part 'reset_password_model.g.dart';

@JsonSerializable()
class ResetPasswordModel extends ResetPasswordEntity {
  const ResetPasswordModel({
    required super.email,
    required super.newPassword,
  });

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ResetPasswordModelToJson(this);

  factory ResetPasswordModel.fromEntity(ResetPasswordEntity entity) {
    return ResetPasswordModel(
      email: entity.email,
      newPassword: entity.newPassword,
    );
  }
}