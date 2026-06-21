import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/forget_password_entity.dart';

part 'forget_password_model.g.dart';

@JsonSerializable()
class ForgetPasswordModel extends ForgetPasswordEntity {
  const ForgetPasswordModel({
    required super.email,
  });

  factory ForgetPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ForgetPasswordModelToJson(this);

  factory ForgetPasswordModel.fromEntity(ForgetPasswordEntity entity) {
    return ForgetPasswordModel(email: entity.email);
  }
}