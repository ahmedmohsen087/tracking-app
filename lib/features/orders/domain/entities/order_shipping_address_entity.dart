import 'package:equatable/equatable.dart';

class OrderShippingAddressEntity extends Equatable{
 final String street;
 final String city;
 final String phone;
 final String lat;
 final String long;
  const OrderShippingAddressEntity({
    required this.street,
    required this.city,
    required this.phone,
    required this.lat,
    required this.long,
});
  @override

  List<Object?> get props => [
    street,
    city,
    phone,
    lat,
    long,
  ];
}