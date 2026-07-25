import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../../../home/presentation/widgets/address_item.dart';
import '../../domain/entities/driver_order_element_entity.dart';
import '../../domain/entities/driver_orders_entity.dart';

class DriverOrderItem extends StatelessWidget {
  final DriverOrderElementEntity orderElement;

  const DriverOrderItem({
    super.key,
    required this.orderElement,
  });

  @override
  Widget build(BuildContext context) {
    context.locale;
    final order = orderElement.order;
    final shippingAddress = order.shippingAddress;
    final userAddress = [
      shippingAddress.street,
      shippingAddress.city,
    ].where((part) => part.isNotEmpty).join(', ');

    final isCompleted = order.state == OrderState.completed;
    final rawOrderNum = order.orderNumber;
    final formattedOrderNum =
        rawOrderNum.isNotEmpty ? rawOrderNum : '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.15),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.flowerOrder,
            style: TextStyles.bodyRegular12.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    isCompleted
                        ? Assets.assetsIconsCheckCircle
                        : Assets.assetsIconsCancel,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      isCompleted ? AppColors.green : AppColors.red,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isCompleted ? AppStrings.completed : AppStrings.cancelled,
                    style: TextStyles.bodyMedium18.copyWith(
                      color: isCompleted ? AppColors.green : AppColors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (formattedOrderNum.isNotEmpty)
                Text(
                  formattedOrderNum,
                  style: TextStyles.bodyMedium18.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.pickupAddress,
            style: TextStyles.bodyRegular12.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 6),
          AddressItem(
            title: orderElement.store.name,
            address: orderElement.store.address,
            image: orderElement.store.image,
            hasShadow: true,
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.userAddress,
            style: TextStyles.bodyRegular12.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 6),
          AddressItem(
            title: '${order.user.firstName} ${order.user.lastName}'.trim(),
            address: userAddress,
            image: order.user.photo,
            hasShadow: true,
          ),
        ],
      ),
    );
  }
}
