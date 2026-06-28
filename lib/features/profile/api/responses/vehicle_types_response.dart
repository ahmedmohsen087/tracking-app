import 'package:flowery_rider_app/features/profile/data/models/vehicle_type_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_types_response.g.dart';

@JsonSerializable()
class VehicleTypesResponse {
  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'vehicles')
  List<VehicleTypeModel>? vehicles;

  VehicleTypesResponse({this.message, this.vehicles});

  factory VehicleTypesResponse.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleTypesResponseToJson(this);
}
