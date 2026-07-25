import 'package:flowery_rider_app/core/utils/haversine_util.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HaversineUtil.distanceMeters', () {
    test('returns 0 meters for two identical points', () {
      const point = LatLngPoint(lat: 30.0444, lng: 31.2357);

      expect(HaversineUtil.distanceMeters(point, point), 0);
    });

    test('returns roughly 200km between Cairo and Alexandria', () {
      const cairo = LatLngPoint(lat: 30.0444, lng: 31.2357);
      const alexandria = LatLngPoint(lat: 31.2001, lng: 29.9187);

      final distance = HaversineUtil.distanceMeters(cairo, alexandria);

      expect(distance, greaterThan(180000));
      expect(distance, lessThan(220000));
    });

    test('returns roughly 50m for nearby points', () {
      const a = LatLngPoint(lat: 30.0, lng: 31.0);
      const b = LatLngPoint(lat: 30.00045, lng: 31.0);

      final distance = HaversineUtil.distanceMeters(a, b);

      expect(distance, greaterThan(40));
      expect(distance, lessThan(60));
    });
  });
}
