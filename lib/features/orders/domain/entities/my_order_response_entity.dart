import 'package:equatable/equatable.dart';

import '../../../home/data/models/metadata.dart';
import '../../data/models/my_order_element.dart';

class MyOrderResponseEntity extends Equatable{
 final String message;
 final Metadata metadata;
 final List<MyOrderElement> orders;
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
