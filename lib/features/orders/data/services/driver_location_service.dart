import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/core/values/firestore_keys.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class DriverLocationService {
  final FirebaseFirestore _firestore;

  DriverLocationService(this._firestore);

  StreamSubscription<Position>? _subscription;

  Future<bool> _ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<void> startTracking(String orderId) async {
    final granted = await _ensurePermission();
    if (!granted) return;

    await stopTracking();

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _subscription = Geolocator.getPositionStream(locationSettings: settings)
        .throttleTime(const Duration(seconds: 3))
        .listen((position) {
      _firestore
          .collection(FirestoreKeys.ordersCollection)
          .doc(orderId)
          .update({
        FirestoreKeys.driverLat: position.latitude,
        FirestoreKeys.driverLng: position.longitude,
      });
    });
  }

  Future<void> stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
