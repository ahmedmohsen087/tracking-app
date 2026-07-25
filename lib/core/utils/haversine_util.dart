import 'dart:math';
import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';

class HaversineUtil {
  static double distanceMeters(LatLngPoint a, LatLngPoint b) {
    const r = 6371000.0;
    final dLat = _rad(b.lat - a.lat);
    final dLng = _rad(b.lng - a.lng);
    final x = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(a.lat)) * cos(_rad(b.lat)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(x), sqrt(1 - x));
    return r * c;
  }

  static double _rad(double deg) => deg * pi / 180;
}
