import 'package:json_annotation/json_annotation.dart';
part 'profile_response_model.g.dart';

@JsonSerializable()
class ProfileResponseModel {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "token")
  String? token;

  ProfileResponseModel({this.message, this.token});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);
}
