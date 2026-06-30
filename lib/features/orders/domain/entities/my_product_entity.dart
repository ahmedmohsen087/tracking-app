import 'package:equatable/equatable.dart';

import '../../data/models/my_product.dart';

class MyProductEntity extends Equatable{
 final Id id;
 final int price;
 const MyProductEntity({
   required this.id,
   required this.price,
 });

  @override

  List<Object?> get props => [
    id,
    price,
  ];

}