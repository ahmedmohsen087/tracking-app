import 'package:equatable/equatable.dart';

class OrderProductEntity extends Equatable{
 final String id;
 final int price;
 const OrderProductEntity({
   required this.id,
   required this.price,
 });

  @override
  List<Object?> get props => [
    id,
    price,
  ];
}