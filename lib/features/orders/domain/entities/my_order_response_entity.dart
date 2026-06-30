import 'package:equatable/equatable.dart';

import 'metadata_entity.dart';
import 'my_order_element_entity.dart';

class MyOrderResponseEntity extends Equatable{
 final String message;
 final MetadataEntity metadata;
 final List<MyOrderElementEntity> orders;
 const MyOrderResponseEntity({
   required this.message,
   required this.metadata,
   required this.orders,
 });

  @override
  List<Object?> get props => [
    message,
    metadata,
    orders,
  ];


}
