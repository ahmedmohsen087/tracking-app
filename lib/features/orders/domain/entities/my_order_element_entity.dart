import 'package:equatable/equatable.dart';

import '../../../auth/data/models/driver_model.dart';
import '../../data/models/my_orders.dart';
import '../../data/models/my_store.dart';

class MyOrderElementEntity extends Equatable{
  final String id;
  final Driver driver;
  final MyOrders order;
  final int v;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MyStore store;
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

