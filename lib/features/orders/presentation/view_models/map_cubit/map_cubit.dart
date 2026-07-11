import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider_app/core/utils/haversine_util.dart';
import 'package:flowery_rider_app/core/values/firestore_keys.dart';
import 'package:flowery_rider_app/core/values/order_status.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/driver_location_entity.dart';
import 'package:flowery_rider_app/features/orders/domain/entities/lat_lng_point.dart';
import 'package:flowery_rider_app/features/orders/domain/use_cases/get_route_use_case.dart';
import 'package:flowery_rider_app/features/orders/domain/use_cases/watch_driver_location_use_case.dart';
import 'package:flowery_rider_app/features/orders/presentation/view_models/map_cubit/map_state.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final WatchDriverLocationUseCase _watchDriverLocation;
  final GetRouteUseCase _getRoute;
  final FirebaseFirestore _firestore;

  MapCubit(this._watchDriverLocation, this._getRoute, this._firestore)
      : super(const MapState());

  StreamSubscription<DriverLocationEntity>? _locationSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _statusSub;
  LatLngPoint? _lastRouteOrigin;
  LatLngPoint? _storePoint;
  LatLngPoint? _buyerPoint;

  static const double _rerouteThresholdMeters = 30.0;

  void init({
    required String orderId,
    required String initialStatus,
    required LatLngPoint storePoint,
    required LatLngPoint buyerPoint,
  }) {
    _storePoint = storePoint;
    _buyerPoint = buyerPoint;
    final destination = _destinationForStatus(initialStatus);
    emit(state.copyWith(destination: destination));

    _statusSub = _firestore
        .collection(FirestoreKeys.ordersCollection)
        .doc(orderId)
        .snapshots()
        .listen((snap) {
      final status = snap.data()?[FirestoreKeys.status] as String?;
      if (status != null) {
        final newDest = _destinationForStatus(status);
        if (newDest != state.destination) {
          _lastRouteOrigin = null;
          emit(state.copyWith(destination: newDest, route: null));
          if (state.driverLocation != null && newDest != null) {
            _fetchRoute(
              LatLngPoint(
                lat: state.driverLocation!.lat,
                lng: state.driverLocation!.lng,
              ),
              newDest,
            );
          }
        }
      }
    });

    _locationSub = _watchDriverLocation(orderId)
        .throttleTime(const Duration(seconds: 3))
        .listen((location) async {
      final current = LatLngPoint(lat: location.lat, lng: location.lng);
      emit(state.copyWith(
        phase: MapPhase.ready,
        driverLocation: location,
      ));
      final dest = state.destination;
      if (dest == null) return;
      final shouldReroute = _lastRouteOrigin == null ||
          HaversineUtil.distanceMeters(current, _lastRouteOrigin!) >
              _rerouteThresholdMeters;
      if (shouldReroute) {
        _lastRouteOrigin = current;
        await _fetchRoute(current, dest);
      }
    });
  }

  Future<void> _fetchRoute(LatLngPoint origin, LatLngPoint destination) async {
    try {
      final route = await _getRoute(origin: origin, destination: destination);
      emit(state.copyWith(route: route));
    } catch (_) {}
  }

  LatLngPoint? _destinationForStatus(String status) {
    const pickupStatuses = [
      OrderStatus.accepted,
      OrderStatus.arrivedPickup,
    ];
    if (pickupStatuses.contains(status)) return _storePoint;
    return _buyerPoint;
  }

  @override
  Future<void> close() async {
    await _locationSub?.cancel();
    await _statusSub?.cancel();
    return super.close();
  }
}
