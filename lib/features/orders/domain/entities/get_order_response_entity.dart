import 'package:equatable/equatable.dart';

import 'metadata_entity.dart';
import 'my_order_element_entity.dart';

class GetOrderResponseEntity extends Equatable{
 final String message;
 final MetadataEntity metadata;
 final List<MyOrderElementEntity> orders;
 const GetOrderResponseEntity({
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
