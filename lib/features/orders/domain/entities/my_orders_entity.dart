import 'package:equatable/equatable.dart';

import '../../../home/data/models/product.dart';
import '../../data/models/my_order_item.dart';
import '../../data/models/my_users.dart';
import '../../data/models/order_shipping_address.dart';

class MyOrdersEntity extends Equatable{
 final String id;
 final MyUsers user;
 final List<MyOrderItem> orderItems;
 final double totalPrice;
 final OrderShippingAddress shippingAddress;
 final PaymentType paymentType;
 final bool isPaid;
 final DateTime paidAt;
 final bool isDelivered;
 final State state;
 final DateTime createdAt;
 final DateTime updatedAt;
 final int v;
 final String orderNumber;
 const MyOrdersEntity({
   required this.id,
   required this.user,
   required this.orderItems,
   required this.totalPrice,
   required this.shippingAddress,
   required this.paymentType,
   required this.isPaid,
   required this.paidAt,
   required this.isDelivered,
   required this.state,
   required this.createdAt,
   required this.updatedAt,
   required this.v,
   required this.orderNumber,

 });

  @override
  List<Object?> get props => [
    id,
    user,
    orderItems,
    totalPrice,
    shippingAddress,
    paymentType,
    isPaid,
    paidAt,
    isDelivered,
    state,
    createdAt,
    updatedAt,
    v,
    orderNumber,
  ];


}