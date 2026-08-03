import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/di/di.dart';
import '../../../../core/reusable_widgets/app_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/api_endpoints.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../../../../core/values/order_status.dart';
import '../../../home/domain/entities/order_entity.dart';
import '../../../home/domain/entities/order_item_entity.dart';
import '../view_models/active_order_view_model/active_order_event.dart';
import '../view_models/active_order_view_model/active_order_state.dart';
import '../view_models/active_order_view_model/active_order_view_model.dart';
import '../widgets/live_map_sheet.dart';
import 'order_success_screen.dart';

Map<String, String> _statusLabels() => {
      OrderStatus.accepted: AppStrings.statusAccepted,
      OrderStatus.arrivedPickup: AppStrings.statusPicked,
      OrderStatus.outForDelivery: AppStrings.statusOutForDelivery,
      OrderStatus.arrivedUser: AppStrings.statusArrived,
      OrderStatus.delivered: AppStrings.statusDelivered,
    };

const List<String> _statusOrder = OrderStatus.progressOrder;

const String _dateTimePattern = 'dd/MM/yyyy  HH:mm';
const double _contactIconSize = 24;

class ActiveOrderScreen extends StatelessWidget {
  final String orderId;
  final OrderEntity order;

  const ActiveOrderScreen({
    super.key,
    required this.orderId,
    required this.order,
  });

  void _onStateListener(BuildContext context, ActiveOrderState state) {
    final update = state.updateOrderState;
    if (update.isLoading) return;
    if (update.msg != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(update.msg!)),
      );
      return;
    }
    if (state.submittedState == OrderStatus.completed) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(orderId: state.orderId),
        ),
      );
    } else if (state.submittedState == OrderStatus.canceled) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutsName.sectionApp,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ActiveOrderViewModel>()..init(orderId),
      child: BlocListener<ActiveOrderViewModel, ActiveOrderState>(
        listenWhen: (prev, curr) =>
            prev.updateOrderState != curr.updateOrderState,
        listener: _onStateListener,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            leading: const BackButton(),
            title: Text(AppStrings.orderDetails),
            centerTitle: false,
          ),
          body: _ActiveOrderBody(orderId: orderId, order: order),
        ),
      ),
    );
  }
}

class _ActiveOrderBody extends StatelessWidget {
  const _ActiveOrderBody({
    required this.orderId,
    required this.order,
  });

  final String orderId;
  final OrderEntity order;

  String? _nextStatus(String current) {
    final idx = _statusOrder.indexOf(current);
    if (idx == -1 || idx >= _statusOrder.length - 1) return null;
    return _statusOrder[idx + 1];
  }

  void _openLiveMap(BuildContext context, String status) {
    final mapHeight = MediaQuery.sizeOf(context).height * 0.85;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SizedBox(
        height: mapHeight,
        child: LiveMapSheet(
          orderId: orderId,
          initialStatus: status,
          order: order,
        ),
      ),
    );
  }

  void _confirmCancelOrder(BuildContext context, String id) {
    final viewModel = context.read<ActiveOrderViewModel>();
    AppDialog.show(
      context: context,
      title: AppStrings.cancelOrderConfirmTitle,
      description: AppStrings.cancelOrderConfirmDescription,
      confirmText: AppStrings.confirm,
      cancelText: AppStrings.cancel,
      onConfirm: () => viewModel.cancelOrder(id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAddress = [
      order.shippingAddress.street,
      order.shippingAddress.city,
    ].where((p) => p.isNotEmpty).join(', ');

    return BlocBuilder<ActiveOrderViewModel, ActiveOrderState>(
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
              name: '${order.user.firstName} ${order.user.lastName}'.trim(),
              address: userAddress,
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
            _ShowMapButton(
              onPressed: () => _openLiveMap(context, state.status),
            ),
            const SizedBox(height: 12),
            if (state.status != OrderStatus.delivered)
              _ActionButton(
                status: state.status,
                userConfirmed: state.userConfirmed,
                isUpdating: state.isUpdating,
                onPressed: () {
                  final next = _nextStatus(state.status);
                  if (next != null) {
                    context.read<ActiveOrderViewModel>().doEvent(
                          UpdateOrderStatusEvent(next),
                        );
                  }
                },
              ),
            if (state.status == OrderStatus.delivered)
              _CompleteButton(
                isLoading: state.updateOrderState.isLoading &&
                    state.submittedState == OrderStatus.completed,
                enabled: !state.updateOrderState.isLoading,
                onPressed: () => context
                    .read<ActiveOrderViewModel>()
                    .completeOrder(state.orderId),
              ),
            const SizedBox(height: 12),
            _CancelButton(
              isLoading: state.updateOrderState.isLoading &&
                  state.submittedState == OrderStatus.canceled,
              enabled: !state.updateOrderState.isLoading,
              onPressed: () => _confirmCancelOrder(context, state.orderId),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class _CompleteButton extends StatelessWidget {
  final bool isLoading;
  final bool enabled;
  final VoidCallback onPressed;

  const _CompleteButton({
    required this.isLoading,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pink,
          disabledBackgroundColor: AppColors.whiteGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text(AppStrings.completeOrder,
                style: TextStyles.buttonTextStyle),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final bool isLoading;
  final bool enabled;
  final VoidCallback onPressed;

  const _CancelButton({
    required this.isLoading,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.pink),
          foregroundColor: AppColors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.pink,
                ),
              )
            : Text(
                AppStrings.cancelOrder,
                style: TextStyles.buttonTextStyle.copyWith(
                  color: AppColors.pink,
                ),
              ),
      ),
    );
  }
}

class _ShowMapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ShowMapButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.map_outlined, color: AppColors.pink),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.pink),
          foregroundColor: AppColors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        label: Text(
          AppStrings.showMap,
          style: TextStyles.buttonTextStyle.copyWith(color: AppColors.pink),
        ),
      ),
    );
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
            margin:
                EdgeInsets.only(right: i < _statusOrder.length - 1 ? 4 : 0),
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
    final dateStr = DateFormat(_dateTimePattern).format(createdAt);

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
                  tooltip: AppStrings.callLabel,
                  icon: SvgPicture.asset(
                    Assets.assetsIconsPhoneCall,
                    width: _contactIconSize,
                    height: _contactIconSize,
                    colorFilter: const ColorFilter.mode(
                      AppColors.green,
                      BlendMode.srcIn,
                    ),
                    semanticsLabel: AppStrings.callLabel,
                  ),
                  onPressed: () => _launchPhone(phone!),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: AppStrings.whatsappLabel,
                  icon: SvgPicture.asset(
                    Assets.assetsIconsWhatsapp,
                    width: _contactIconSize,
                    height: _contactIconSize,
                    semanticsLabel: AppStrings.whatsappLabel,
                  ),
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
          style:
              TextStyles.bodyRegular14.copyWith(fontWeight: FontWeight.w600),
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
                  child:
                      Text('$title × $qty', style: TextStyles.bodyRegular13),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
      case OrderStatus.accepted:
        return AppStrings.actionArrivedPickup;
      case OrderStatus.arrivedPickup:
        return AppStrings.actionStartDeliver;
      case OrderStatus.outForDelivery:
        return AppStrings.actionArrivedToUser;
      case OrderStatus.arrivedUser:
        return AppStrings.actionDeliveredToUser;
      default:
        return '';
    }
  }

  bool _isEnabled() {
    if (status == OrderStatus.delivered) return false;
    if (status == OrderStatus.arrivedUser) return userConfirmed;
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
