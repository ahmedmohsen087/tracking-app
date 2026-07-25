import 'package:equatable/equatable.dart';

import 'driver_orders_entity.dart';
import 'my_store_entity.dart';

class DriverOrderElementEntity extends Equatable {
  final String id;
  final String driver;
  final DriverOrderEntity order;
  final int v;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MyStoreEntity store;
  const DriverOrderElementEntity({
    required this.id,
    required this.driver,
    required this.order,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
    required this.store,
  });

  @override
  List<Object?> get props => [
        id,
        driver,
        order,
        v,
        createdAt,
        updatedAt,
        store,
      ];
}
