import 'package:flowery_rider_app/features/home/data/models/order_item.dart';
import 'package:flowery_rider_app/features/home/domain/entities/order_item_entity.dart';
import 'package:flowery_rider_app/features/home/domain/entities/product_entity.dart';
import 'product_model_mapper.dart';

extension OrderItemModelMapper on OrderItem {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      product: product?.toEntity() ??
          const ProductEntity(
            id: '',
            title: '',
            description: '',
            imgCover: '',
            price: 0,
            priceAfterDiscount: 0,
            discount: 0,
          ),
      price: (price ?? 0).toDouble(),
      quantity: quantity ?? 0,
      id: id ?? '',
    );
  }
}
