import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';

class NumberItem extends StatelessWidget {
  final String numberOfOrders;
  final bool isCancelled;
  const NumberItem({
    super.key,
    required this.numberOfOrders,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsetsDirectional.only(start: 14, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            numberOfOrders,
            style: TextStyles.bodyMedium18,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SvgPicture.asset(
                isCancelled
                    ? Assets.assetsIconsCancel
                    : Assets.assetsIconsCheckCircle,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isCancelled ? AppColors.red : AppColors.green,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                isCancelled ? AppStrings.cancelled : AppStrings.completed,
                style: TextStyles.bodyRegular16.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
