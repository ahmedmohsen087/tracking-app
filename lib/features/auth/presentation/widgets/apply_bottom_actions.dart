import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

class ApplyGenderRow extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const ApplyGenderRow({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(AppStrings.gender, style: TextStyles.bodyRegular14),
        const SizedBox(width: 16),
        InkWell(
          onTap: () => onChanged('female'),
          child: Row(
            children: [
              Radio<String>(
                value: 'female',
                groupValue: selected,
                onChanged: onChanged,
                activeColor: AppColors.pink,
              ),
              Text(AppStrings.female, style: TextStyles.bodyRegular14),
            ],
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => onChanged('male'),
          child: Row(
            children: [
              Radio<String>(
                value: 'male',
                groupValue: selected,
                onChanged: onChanged,
                activeColor: AppColors.pink,
              ),
              Text(AppStrings.male, style: TextStyles.bodyRegular14),
            ],
          ),
        ),
      ],
    );
  }
}

class ApplySubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const ApplySubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 2.5,
              ),
            )
          : Text(AppStrings.continueText),
    );
  }
}
