import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';

class VehicleInfoCard extends StatelessWidget {
  final String? kindOfVehicle;
  final String? vehicleNumber;
  final VoidCallback? onTap;
  const VehicleInfoCard({
    super.key,
    this.kindOfVehicle,
    this.vehicleNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
      height: 108,
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.vehicleInfo,
                  style: TextStyles.bodyMedium18,),
                Text(kindOfVehicle!,
                  style: TextStyles.bodyRegular16,),
                Text(vehicleNumber!,
                  style: TextStyles.bodyRegular16,),

              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios,),
          ],
        ),
      ),
      ),
    );
  }
}
