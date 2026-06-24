import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import 'address_item.dart';
import 'item_selected.dart';

class FlowerOrderItem extends StatelessWidget {
  const FlowerOrderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],


      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.flowerOrder,
              style: TextStyles.textFieldTextStyle,
            ),
            Text(AppStrings.pickupAddress,
              style: TextStyles.bodyRegular12.copyWith(
                color: AppColors.grey
              ),
            ),
            AddressItem(),
            Text(AppStrings.userAddress,
              style: TextStyles.bodyRegular12.copyWith(
                  color: AppColors.grey
              ),
            ),
            AddressItem(),
            ItemSelected(),
          ],
        ),
      ),


    );
  }
}
