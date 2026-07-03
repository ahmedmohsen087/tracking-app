import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/metadata_entity.dart';
part 'meta_data.g.dart';
@JsonSerializable()
class Metadata {
  @JsonKey(name: "currentPage")
  int? currentPage;
  @JsonKey(name: "totalPages")
  int? totalPages;
  @JsonKey(name: "totalItems")
  int? totalItems;
  @JsonKey(name: "limit")
  int? limit;

  Metadata({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.limit,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);

  MetadataEntity toDomain() {
    return MetadataEntity(
      currentPage: currentPage ?? 1,
      totalPages: totalPages ?? 1,
      totalItems: totalItems ?? 0,
      limit: limit ?? 10,
    );
  }
}