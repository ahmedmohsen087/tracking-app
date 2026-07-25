import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../config/di/di.dart';
import '../../../../core/values/app_strings.dart';
import '../../../home/domain/entities/order_entity.dart';
import '../../domain/entities/lat_lng_point.dart';
import '../view_models/map_cubit/map_cubit.dart';
import '../view_models/map_cubit/map_state.dart';

const LatLngPoint _kStoreLocation = LatLngPoint(lat: 29.9602, lng: 31.2569);

class LiveMapSheet extends StatelessWidget {
  final String orderId;
  final String initialStatus;
  final OrderEntity order;

  const LiveMapSheet({
    super.key,
    required this.orderId,
    required this.initialStatus,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MapCubit>(),
      child: _LiveMapView(
        orderId: orderId,
        initialStatus: initialStatus,
        order: order,
      ),
    );
  }
}

class _LiveMapView extends StatefulWidget {
  final String orderId;
  final String initialStatus;
  final OrderEntity order;

  const _LiveMapView({
    required this.orderId,
    required this.initialStatus,
    required this.order,
  });

  @override
  State<_LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends State<_LiveMapView> {
  final MapController _mapController = MapController();

  LatLngPoint _parseBuyerPoint(String lat, String long) {
    return LatLngPoint(
      lat: double.tryParse(lat.trim()) ?? 0.0,
      lng: double.tryParse(long.trim()) ?? 0.0,
    );
  }

  @override
  void initState() {
    super.initState();
    final buyerPoint = _parseBuyerPoint(
      widget.order.shippingAddress.lat,
      widget.order.shippingAddress.long,
    );
    context.read<MapCubit>().init(
      orderId: widget.orderId,
      initialStatus: widget.initialStatus,
      storePoint: _kStoreLocation,
      buyerPoint: buyerPoint,
    );
  }

  bool _isPickup(LatLngPoint destination) {
    return destination.lat == _kStoreLocation.lat &&
        destination.lng == _kStoreLocation.lng;
  }

  List<LatLng> _polylinePoints(MapState state) {
    final waypoints = state.route?.waypoints;
    if (waypoints != null && waypoints.isNotEmpty) {
      return waypoints.map((p) => LatLng(p.lat, p.lng)).toList();
    }
    final driver = state.driverLocation;
    final dest = state.destination;
    if (driver != null && dest != null) {
      return [LatLng(driver.lat, driver.lng), LatLng(dest.lat, dest.lng)];
    }
    return [];
  }

  void _fitCamera(MapState state) {
    final points = <LatLng>[];
    final driver = state.driverLocation;
    final dest = state.destination;
    if (driver != null) points.add(LatLng(driver.lat, driver.lng));
    if (dest != null) points.add(LatLng(dest.lat, dest.lng));
    final waypoints = state.route?.waypoints;
    if (waypoints != null) {
      points.addAll(waypoints.map((p) => LatLng(p.lat, p.lng)));
    }
    if (points.length < 2) return;
    final bounds = LatLngBounds.fromPoints(points);
    if (bounds.northEast.latitude == bounds.southWest.latitude &&
        bounds.northEast.longitude == bounds.southWest.longitude) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        _mapController.fitCamera(
          CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(48)),
        );
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: BlocConsumer<MapCubit, MapState>(
            listener: (context, state) => _fitCamera(state),
            builder: (context, state) {
              if (state.phase == MapPhase.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildMap(state);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMap(MapState state) {
    final driver = state.driverLocation;
    final dest = state.destination;
    final polylinePoints = _polylinePoints(state);
    final center = driver != null
        ? LatLng(driver.lat, driver.lng)
        : LatLng(_kStoreLocation.lat, _kStoreLocation.lng);
    final size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.height * 0.75,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: center, initialZoom: 13),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.tracking_app',
              ),
              if (polylinePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polylinePoints,
                      strokeWidth: 4,
                      color: Colors.blue,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(_kStoreLocation.lat, _kStoreLocation.lng),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.storefront,
                      color: Colors.pink,
                      size: 36,
                    ),
                  ),
                  if (driver != null)
                    Marker(
                      point: LatLng(driver.lat, driver.lng),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.delivery_dining,
                        color: Colors.blue,
                        size: 36,
                      ),
                    ),
                  if (dest != null && !_isPickup(dest))
                    Marker(
                      point: LatLng(dest.lat, dest.lng),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 36,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (dest != null)
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _isPickup(dest)
                      ? AppStrings.goingToPickup
                      : AppStrings.goingToDelivery,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
