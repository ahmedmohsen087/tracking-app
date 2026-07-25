import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imgCover;
  final List<String> images;
  final double price;
  final double priceAfterDiscount;
  final int discount;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imgCover,
    this.images = const [],
    required this.price,
    required this.priceAfterDiscount,
    required this.discount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imgCover,
    images,
    price,
    priceAfterDiscount,
    discount,
  ];
}
