import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class ItemSelected extends StatelessWidget {
  final double price;
  final VoidCallback onReject;
  final VoidCallback onAccept;
  final bool isAccepting;

  const ItemSelected({
    super.key,
    required this.price,
    required this.onReject,
    required this.onAccept,
    this.isAccepting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        spacing: 10,
        children: [
          Text(
            '${AppStrings.egp} $price',
            style: TextStyles.textFieldTextStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.white),
              ),
              onPressed: isAccepting ? null : onReject,
              child: Text(
                AppStrings.reject,
                style: TextStyles.textFieldTextStyle.copyWith(
                  color: AppColors.pink,
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: isAccepting ? null : onAccept,
              child: isAccepting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : Text(AppStrings.accept),
            ),
          ),
        ],
      ),
    );
  }
}
