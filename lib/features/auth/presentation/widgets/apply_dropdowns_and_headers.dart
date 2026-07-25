import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/utils/validation/app_validations.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flowery_rider_app/core/values/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ApplyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ApplyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset(
          Assets.assetsIconsArrowBack,
          matchTextDirection: true,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(AppStrings.apply),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.welcomeExclamation,
          style: TextStyles.bodyMedium18.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.applySubtitle,
          style: TextStyles.bodyRegular14.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }
}

class CountryDropdown extends StatelessWidget {
  final String value;
  final List<Map<String, String>> countries;
  final ValueChanged<Map<String, String>> onChanged;

  const CountryDropdown({
    super.key,
    required this.value,
    required this.countries,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Map<String, String>>(
      isExpanded: true,
      menuMaxHeight: 300,
      initialValue: countries.firstWhere((c) => c['id'] == value),
      decoration: InputDecoration(
        labelText: AppStrings.country,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      items: countries
          .map(
            (c) => DropdownMenuItem(
              value: c,
              child: Row(
                children: [
                  Text(
                    c['flag'] ?? '',
                    style: const TextStyle(fontSize: 22, height: 1.2),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      c['label'] ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      validator: (v) => AppValidations.validateRequired(
        v?['id'] ?? '',
        AppStrings.countryRequired,
      ),
    );
  }
}

class VehicleTypeDropdown extends StatelessWidget {
  final String value;
  final List<Map<String, String>> types;
  final ValueChanged<Map<String, String>> onChanged;

  const VehicleTypeDropdown({
    super.key,
    required this.value,
    required this.types,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Map<String, String>>(
      isExpanded: true,
      menuMaxHeight: 300,
      initialValue: types.firstWhere((t) => t['label'] == value),
      decoration: InputDecoration(
        labelText: AppStrings.vehicleType,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      items: types
          .map(
            (t) => DropdownMenuItem(
              value: t,
              child: Text(t['label']!, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      validator: (v) => AppValidations.validateRequired(
        v?['id'] ?? '',
        AppStrings.vehicleTypeRequired,
      ),
    );
  }
}
