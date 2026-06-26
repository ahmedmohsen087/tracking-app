import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? imgCover;
  final List<String> images;
  final double? price;
  final double? priceAfterDiscount;
  final int? discount;

  const ProductEntity({
    this.id,
    this.title,
    this.description,
    this.imgCover,
    this.images = const [],
    this.price,
    this.priceAfterDiscount,
    this.discount,
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
