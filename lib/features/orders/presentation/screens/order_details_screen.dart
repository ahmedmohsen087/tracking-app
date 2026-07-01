import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/api_endpoints.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../../../home/domain/entities/order_entity.dart';
import '../../../home/domain/entities/order_item_entity.dart';
import '../view_models/order_details_view_model/order_details_event.dart';
import '../view_models/order_details_view_model/order_details_state.dart';
import '../view_models/order_details_view_model/order_details_view_model.dart';
import 'order_success_screen.dart';

Map<String, String> _statusLabels() => {
  'accepted': AppStrings.statusAccepted,
  'arrived_pickup': AppStrings.statusPicked,
  'out_for_delivery': AppStrings.statusOutForDelivery,
  'arrived_user': AppStrings.statusArrived,
  'delivered': AppStrings.statusDelivered,
};

const List<String> _statusOrder = [
  'accepted',
  'arrived_pickup',
  'out_for_delivery',
  'arrived_user',
  'delivered',
];

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final OrderEntity order;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderDetailsViewModel>()..init(orderId),
      child: BlocListener<OrderDetailsViewModel, OrderDetailsState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status && curr.status == 'delivered',
        listener: (context, state) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderSuccessScreen(orderId: state.orderId),
            ),
          );
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            leading: const BackButton(),
            title: Text(AppStrings.orderDetails),
            centerTitle: false,
          ),
          body: BlocBuilder<OrderDetailsViewModel, OrderDetailsState>(
            builder: (context, state) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _ProgressBar(status: state.status),
                  const SizedBox(height: 16),
                  _StatusCard(
                    status: state.status,
                    orderNumber: order.orderNumber,
                    createdAt: order.createdAt,
                  ),
                  const SizedBox(height: 16),
                  _AddressCard(
                    label: AppStrings.pickupAddress,
                    name: order.store.name,
                    address: order.store.address,
                    imageUrl: order.store.image,
                    phone: order.store.phoneNumber,
                  ),
                  const SizedBox(height: 16),
                  _AddressCard(
                    label: AppStrings.userAddress,
                    name: '${order.user.firstName} ${order.user.lastName}'
                        .trim(),
                    address: [
                      order.shippingAddress.street,
                      order.shippingAddress.city,
                    ].where((p) => p.isNotEmpty).join(', '),
                    imageUrl: order.user.photo,
                    phone: order.shippingAddress.phone,
                  ),
                  const SizedBox(height: 16),
                  _OrderItemsList(items: order.orderItems),
                  const SizedBox(height: 16),
                  _TotalRow(
                    total: order.totalPrice,
                    paymentMethod: order.paymentType,
                  ),
                  const SizedBox(height: 24),
                  _ActionButton(
                    status: state.status,
                    userConfirmed: state.userConfirmed,
                    isUpdating: state.isUpdating,
                    onPressed: () {
                      final next = _nextStatus(state.status);
                      if (next != null) {
                        context.read<OrderDetailsViewModel>().doEvent(
                          UpdateOrderStatusEvent(next),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String? _nextStatus(String current) {
    final idx = _statusOrder.indexOf(current);
    if (idx == -1 || idx >= _statusOrder.length - 1) return null;
    return _statusOrder[idx + 1];
  }
}

class _ProgressBar extends StatelessWidget {
  final String status;

  const _ProgressBar({required this.status});

  @override
  Widget build(BuildContext context) {
    final activeIndex = _statusOrder.indexOf(status);

    return Row(
      children: List.generate(_statusOrder.length, (i) {
        final isActive = i <= activeIndex;
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: i < _statusOrder.length - 1 ? 4 : 0),
            decoration: BoxDecoration(
              color: isActive ? AppColors.pink : AppColors.whiteGrey,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String status;
  final String orderNumber;
  final DateTime createdAt;

  const _StatusCard({
    required this.status,
    required this.orderNumber,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final label = _statusLabels()[status] ?? status;
    final dateStr =
        '${createdAt.day}/${createdAt.month}/${createdAt.year}  '
        '${createdAt.hour.toString().padLeft(2, '0')}:'
        '${createdAt.minute.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${AppStrings.statusLabel} : ',
                style: TextStyles.textFieldTextStyle,
              ),
              Text(
                label,
                style: TextStyles.textFieldTextStyle.copyWith(
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${AppStrings.orderIdLabel} : $orderNumber',
            style: TextStyles.bodyRegular13,
          ),
          const SizedBox(height: 4),
          Text(
            dateStr,
            style: TextStyles.bodyRegular12.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String label;
  final String? name;
  final String? address;
  final String? imageUrl;
  final String? phone;

  const _AddressCard({
    required this.label,
    this.name,
    this.address,
    this.imageUrl,
    this.phone,
  });

  Future<void> _launchPhone(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchWhatsApp(String number) async {
    final normalized = number.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$normalized');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullImageUrl = ApiEndpoints.imageUrl(imageUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.bodyRegular12.copyWith(color: AppColors.grey),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withValues(alpha: 0.3),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.lightPink,
                backgroundImage: fullImageUrl.isNotEmpty
                    ? NetworkImage(fullImageUrl)
                    : null,
                child: fullImageUrl.isEmpty
                    ? SvgPicture.asset(
                        Assets.assetsIconsPerson,
                        width: 22,
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          AppColors.pink,
                          BlendMode.srcIn,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (name?.isNotEmpty == true)
                      Text(
                        name!,
                        style: TextStyles.bodyRegular13.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (address?.isNotEmpty == true)
                      Text(
                        address!,
                        style: TextStyles.bodyRegular12.copyWith(
                          color: AppColors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (phone?.isNotEmpty == true) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.call_outlined, color: AppColors.green),
                  onPressed: () => _launchPhone(phone!),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.chat_outlined, color: AppColors.green),
                  onPressed: () => _launchWhatsApp(phone!),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderItemsList extends StatelessWidget {
  final List<OrderItemEntity> items;

  const _OrderItemsList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.orderItems,
          style: TextStyles.bodyRegular14.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          final product = item.product;
          final title = product.title.isNotEmpty
              ? product.title
              : AppStrings.itemFallback;
          final qty = item.quantity;
          final price = item.price;
          final imgUrl = ApiEndpoints.imageUrl(product.imgCover);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                if (imgUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imgUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.lightPink,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_florist,
                      color: AppColors.pink,
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('$title × $qty', style: TextStyles.bodyRegular13),
                ),
                Text(
                  '${AppStrings.egp} ${(price * qty).toStringAsFixed(0)}',
                  style: TextStyles.textFieldTextStyle,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  final double total;
  final String paymentMethod;

  const _TotalRow({required this.total, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.totalLabel,
              style: TextStyles.bodyRegular12.copyWith(color: AppColors.grey),
            ),
            Text(
              '${AppStrings.egp} ${total.toStringAsFixed(0)}',
              style: TextStyles.textFieldTextStyle.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
        if (paymentMethod.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.lightPink,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              paymentMethod,
              style: TextStyles.bodyRegular12.copyWith(color: AppColors.pink),
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String status;
  final bool userConfirmed;
  final bool isUpdating;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.status,
    required this.userConfirmed,
    required this.isUpdating,
    required this.onPressed,
  });

  String _label() {
    switch (status) {
      case 'accepted':
        return AppStrings.actionArrivedPickup;
      case 'arrived_pickup':
        return AppStrings.actionStartDeliver;
      case 'out_for_delivery':
        return AppStrings.actionArrivedToUser;
      case 'arrived_user':
        return AppStrings.actionDeliveredToUser;
      default:
        return '';
    }
  }

  bool _isEnabled() {
    if (status == 'delivered') return false;
    if (status == 'arrived_user') return userConfirmed;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _isEnabled() && !isUpdating;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? AppColors.pink : AppColors.grey,
          disabledBackgroundColor: AppColors.whiteGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isUpdating
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text(_label(), style: TextStyles.buttonTextStyle),
      ),
    );
  }
}
