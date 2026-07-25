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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.grey.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.vehicleInfo,
                    style: TextStyles.bodyMedium18.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (kindOfVehicle != null && kindOfVehicle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      kindOfVehicle!,
                      style: TextStyles.bodyRegular14.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                  if (vehicleNumber != null && vehicleNumber!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      vehicleNumber!,
                      style: TextStyles.bodyRegular14.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
