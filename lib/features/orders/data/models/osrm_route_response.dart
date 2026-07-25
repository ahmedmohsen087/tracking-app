import 'package:json_annotation/json_annotation.dart';

part 'osrm_route_response.g.dart';

@JsonSerializable()
class OsrmRouteResponse {
  final List<OsrmRoute>? routes;
  final String? code;

  const OsrmRouteResponse({this.routes, this.code});

  factory OsrmRouteResponse.fromJson(Map<String, dynamic> json) =>
      _$OsrmRouteResponseFromJson(json);
}

@JsonSerializable()
class OsrmRoute {
  final OsrmGeometry? geometry;
  final double? distance;
  final double? duration;

  const OsrmRoute({this.geometry, this.distance, this.duration});

  factory OsrmRoute.fromJson(Map<String, dynamic> json) =>
      _$OsrmRouteFromJson(json);
}

@JsonSerializable()
class OsrmGeometry {
  final List<List<double>>? coordinates;

  const OsrmGeometry({this.coordinates});

  factory OsrmGeometry.fromJson(Map<String, dynamic> json) =>
      _$OsrmGeometryFromJson(json);
}
