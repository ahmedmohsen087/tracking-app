import 'package:equatable/equatable.dart';

class MyStoreEntity extends Equatable{
  final String name;
  final String image;
  final String address;
  final String phoneNumber;
  final String latLong;
  const MyStoreEntity({
    required this.name,
    required this.image,
    required this.address,
    required this.phoneNumber,
    required this.latLong,
});

  @override
  List<Object?> get props => [
    name,
    image,
    address,
    phoneNumber,
    latLong,
  ];
}