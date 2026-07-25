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

class OrderDetailsScreen extends StatelessWidget {
  final DriverOrderElementEntity orderElement;

  const OrderDetailsScreen({super.key, required this.orderElement});

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

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: SvgPicture.asset(
            Assets.assetsIconsArrowBack,
            width: 24,
            height: 24,
            matchTextDirection: true,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppStrings.orderDetails, style: TextStyles.appBarTextStyle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Order Number Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      isCompleted
                          ? Assets.assetsIconsCheckCircle
                          : Assets.assetsIconsCancel,
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        isCompleted ? AppColors.green : AppColors.red,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isCompleted ? AppStrings.completed : AppStrings.cancelled,
                      style: TextStyles.bodyMedium18.copyWith(
                        color: isCompleted ? AppColors.green : AppColors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Text(
                  order.orderNumber,
                  style: TextStyles.bodyMedium18.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Pickup Address Section
            Text(
              AppStrings.pickupAddress,
              style: TextStyles.bodyMedium18.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            AddressItem(
              title: orderElement.store.name,
              address: orderElement.store.address,
              image: orderElement.store.image,
              hasShadow: true,
            ),
            const SizedBox(height: 20),

            // User Address Section
            Text(
              AppStrings.userAddress,
              style: TextStyles.bodyMedium18.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            AddressItem(
              title: '${order.user.firstName} ${order.user.lastName}'.trim(),
              address: userAddress,
              image: order.user.photo,
              hasShadow: true,
            ),
            const SizedBox(height: 20),

            // Order Details (Items) Section
            Text(
              AppStrings.orderDetails,
              style: TextStyles.bodyMedium18.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (order.orderItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(AppStrings.noOrdersAvailable),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.orderItems.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = order.orderItems[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey.withValues(alpha: 0.30),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.lightPink,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              Assets.assetsIconsCheckCircle,
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                AppColors.pink,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.flowerOrder,
                                style: TextStyles.bodyRegular12.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${AppStrings.egp} ${item.price.toStringAsFixed(0)}',
                                style: TextStyles.bodyMedium18.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'X${item.quantity}',
                          style: TextStyles.bodyMedium18.copyWith(
                            color: AppColors.pink,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),

            // Total Section
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withValues(alpha: 0.30),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.totalLabel,
                    style: TextStyles.bodyMedium18.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${AppStrings.egp} ${order.totalPrice.toStringAsFixed(0)}',
                    style: TextStyles.bodyMedium18.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Method Section
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withValues(alpha: 0.30),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.paymentMethod,
                    style: TextStyles.bodyMedium18.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    order.paymentType == PaymentType.cash
                        ? AppStrings.cashOnDelivery
                        : AppStrings.creditCard,
                    style: TextStyles.bodyRegular12.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
