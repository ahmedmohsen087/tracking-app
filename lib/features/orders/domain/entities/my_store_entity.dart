import 'package:equatable/equatable.dart';

import '../../../home/data/models/store.dart';

class MyStoreEntity extends Equatable{
  final Name name;
  final String image;
  final Address address;
  final String phoneNumber;
  final LatLong latLong;
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