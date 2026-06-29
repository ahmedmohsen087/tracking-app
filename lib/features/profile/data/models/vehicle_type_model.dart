import 'package:flowery_rider_app/features/profile/domain/entities/vehicle_type_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_type_model.g.dart';

@JsonSerializable()
class VehicleTypeModel {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'image')
  String? image;

  VehicleTypeModel({this.id, this.type, this.image});

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleTypeModelToJson(this);

  VehicleTypeEntity toEntity() {
    return VehicleTypeEntity(id: id, type: type, image: image);
  }
}
