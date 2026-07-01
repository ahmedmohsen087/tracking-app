import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';

class NumberItem extends StatelessWidget {
  final String numberOfOrders;
  final bool isCancelled;
  const NumberItem({
    super.key,
    required this.numberOfOrders ,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightPink,
      width: 155,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(numberOfOrders,
              style: TextStyles.bodyMedium18,
            ),
            isCancelled ?Row(
              spacing: 10,
              children: [
                Icon(Icons.cancel_outlined,
                  color: AppColors.red,),
                Text(AppStrings.cancelled,)
              ],
            ):Row(
              spacing: 10,
              children: [
                Icon(Icons.check_circle_outline_outlined,
                  color: AppColors.green,),
                Text(AppStrings.completed,)
              ],
            ),
          ],
        ),
      ),

    );
  }
}
