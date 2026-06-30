import 'package:equatable/equatable.dart';

class MyProductEntity extends Equatable{
 final String id;
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