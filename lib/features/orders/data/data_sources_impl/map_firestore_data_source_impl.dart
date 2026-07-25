import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/core/values/firestore_keys.dart';
import 'package:flowery_rider_app/features/orders/data/data_sources_contract/map_firestore_data_source_contract.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/driver_location_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MapFirestoreDataSourceContract)
class MapFirestoreDataSourceImpl implements MapFirestoreDataSourceContract {
  final FirebaseFirestore _firestore;

  MapFirestoreDataSourceImpl(this._firestore);

  @override
  Stream<DriverLocationEntity> watchDriverLocation(String orderId) {
    return _firestore
        .collection(FirestoreKeys.ordersCollection)
        .doc(orderId)
        .snapshots()
        .where((snap) =>
            snap.data()?.containsKey(FirestoreKeys.driverLat) == true &&
            snap.data()?.containsKey(FirestoreKeys.driverLng) == true)
        .map((snap) {
      final data = snap.data()!;
      return DriverLocationEntity(
        lat: (data[FirestoreKeys.driverLat] as num).toDouble(),
        lng: (data[FirestoreKeys.driverLng] as num).toDouble(),
      );
    });
  }
}
