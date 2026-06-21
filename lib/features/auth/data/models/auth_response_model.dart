import 'package:flowery_rider_app/features/auth/data/models/driver_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "driver")
    Driver? driver;
    @JsonKey(name: "token")
    String? token;

    AuthResponseModel({
        this.message,
        this.driver,
        this.token,
    });

    factory AuthResponseModel.fromJson(Map<String, dynamic> json) => _$AuthResponseModelFromJson(json);

    Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
