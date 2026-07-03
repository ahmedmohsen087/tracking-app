import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/driver_entity.dart';
import 'my_orders_entity.dart';
import 'my_store_entity.dart';

class MyOrderElementEntity extends Equatable{
  final String id;
  final DriverEntity driver;
  final MyOrdersEntity order;
  final int v;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MyStoreEntity store;
  const MyOrderElementEntity({
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

