import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../../../home/presentation/widgets/address_item.dart';
import '../../domain/entities/driver_order_element_entity.dart';
import '../../domain/entities/driver_order_item_entity.dart';
import '../../domain/entities/driver_orders_entity.dart';

class OrderDetailsScreen extends StatelessWidget {
  final DriverOrderElementEntity orderElement;

  const OrderDetailsScreen({super.key, required this.orderElement});

  @override
  Widget build(BuildContext context) {
    context.locale;
    final order = orderElement.order;
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
            _OrderStatusHeader(
              isCompleted: isCompleted,
              orderNumber: order.orderNumber,
            ),
            const SizedBox(height: 20),
            _OrderAddressesSection(orderElement: orderElement),
            const SizedBox(height: 20),
            _OrderItemsList(orderItems: order.orderItems),
            const SizedBox(height: 20),
            _OrderTotalSection(totalPrice: order.totalPrice),
            const SizedBox(height: 24),
            _OrderPaymentMethodSection(paymentType: order.paymentType),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _OrderStatusHeader extends StatelessWidget {
  const _OrderStatusHeader({
    required this.isCompleted,
    required this.orderNumber,
  });

  final bool isCompleted;
  final String orderNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          orderNumber,
          style: TextStyles.bodyMedium18.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _OrderAddressesSection extends StatelessWidget {
  const _OrderAddressesSection({required this.orderElement});

  final DriverOrderElementEntity orderElement;

  @override
  Widget build(BuildContext context) {
    final order = orderElement.order;
    final shippingAddress = order.shippingAddress;
    final userAddress = [
      shippingAddress.street,
      shippingAddress.city,
    ].where((part) => part.isNotEmpty).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}

class _OrderItemsList extends StatelessWidget {
  const _OrderItemsList({required this.orderItems});

  final List<DriverOrderItemEntity> orderItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.orderDetails,
          style: TextStyles.bodyMedium18.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (orderItems.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(AppStrings.noOrdersAvailable),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderItems.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _OrderItemCard(item: orderItems[index]),
          ),
      ],
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({required this.item});

  final DriverOrderItemEntity item;

  @override
  Widget build(BuildContext context) {
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
  }
}

class _OrderTotalSection extends StatelessWidget {
  const _OrderTotalSection({required this.totalPrice});

  final double totalPrice;

  @override
  Widget build(BuildContext context) {
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
            '${AppStrings.egp} ${totalPrice.toStringAsFixed(0)}',
            style: TextStyles.bodyMedium18.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderPaymentMethodSection extends StatelessWidget {
  const _OrderPaymentMethodSection({required this.paymentType});

  final PaymentType paymentType;

  @override
  Widget build(BuildContext context) {
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
            paymentType == PaymentType.cash
                ? AppStrings.cashOnDelivery
                : AppStrings.creditCard,
            style: TextStyles.bodyRegular12.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
