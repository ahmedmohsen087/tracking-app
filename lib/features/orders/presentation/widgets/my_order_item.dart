import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../../home/presentation/widgets/address_item.dart';
import '../../domain/entities/my_order_element_entity.dart';

class MyOrderItem extends StatelessWidget {
  final MyOrderElementEntity orderElement;

  const MyOrderItem({
    super.key,
    required this.orderElement,
  });

  @override
  Widget build(BuildContext context) {
    final order = orderElement.order;
    final shippingAddress = order.shippingAddress;
    final userAddress = [
      shippingAddress.street,
      shippingAddress.city,
    ].where((part) => part.isNotEmpty).join(', ');

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(
            context,
            AppRoutsName.orderDetailsScreen,
            arguments: orderElement,
          ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            if (order.orderNumber.isNotEmpty)
              Text(
                '#${order.orderNumber}',
                style: TextStyles.bodyMedium18,
              ),
            Text(
              AppStrings.pickupAddress,
              style: TextStyles.bodyRegular12.copyWith(color: AppColors.grey),
            ),
            AddressItem(
              title: orderElement.store.name,
              address: orderElement.store.address,
              image: orderElement.store.image,
            ),
            Text(
              AppStrings.userAddress,
              style: TextStyles.bodyRegular12.copyWith(color: AppColors.grey),
            ),
            AddressItem(
              title: order.user.firstName,
              address: userAddress,
              image: order.user.photo,
            ),
          ],
        ),
      ),
    );
  }
}
