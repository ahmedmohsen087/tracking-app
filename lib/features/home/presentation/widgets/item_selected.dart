import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class ItemSelected extends StatelessWidget {
  final double? price;
  final VoidCallback onReject;

  const ItemSelected({super.key, this.price, required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child:

          Row(
            spacing: 10,
            children: [
              Text(
                'EGP ${price ?? 0}',
                style: TextStyles.textFieldTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.white),
                  ),
                  onPressed: onReject,
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
                  onPressed: () {},
                  child: Text(AppStrings.accept),
                ),
              ),
            ],
          ),);

  }
}
