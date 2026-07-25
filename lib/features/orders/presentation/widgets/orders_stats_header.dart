import 'package:flutter/material.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import 'number_item.dart';

class OrdersStatsHeader extends StatelessWidget {
  final int cancelledCount;
  final int completedCount;

  const OrdersStatsHeader({
    super.key,
    required this.cancelledCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NumberItem(
              numberOfOrders: cancelledCount.toString(),
              isCancelled: true,
            ),
            NumberItem(
              numberOfOrders: completedCount.toString(),
              isCancelled: false,
            ),
          ],
        ),
        Text(
          AppStrings.recentOrders,
          style: TextStyles.bodyMedium18,
        ),
      ],
    );
  }
}
