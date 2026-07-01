import 'package:flowery_rider_app/features/home/data/models/product.dart';
import 'package:flowery_rider_app/features/home/domain/entities/product_entity.dart';

extension ProductModelMapper on Product {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id ?? '',
      title: title ?? '',
      description: description ?? '',
      imgCover: imgCover ?? '',
      images: images ?? [],
      price: (price ?? 0).toDouble(),
      priceAfterDiscount: (priceAfterDiscount ?? 0).toDouble(),
      discount: discount ?? 0,
    );
  }
}
