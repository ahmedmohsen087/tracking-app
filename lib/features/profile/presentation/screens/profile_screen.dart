import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/view_models/logout_view_model/logout_view_model.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';
import '../view_models/get_profile_view_model/get_profile_state.dart';
import '../view_models/get_profile_view_model/get_profile_view_model.dart';
import '../widgets/logout_widget.dart';
import '../widgets/personal_information_card.dart';
import '../widgets/vehicle_info_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLanguageBottomSheet(BuildContext context) {
    final currentLocale = context.locale;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.language, style: TextStyles.bodyRegular16),
              const SizedBox(height: 16),
              _LanguageOption(
                label: AppStrings.english,
                selected: currentLocale.languageCode == 'en',
                onTap: () {
                  context.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1),
              _LanguageOption(
                label: AppStrings.arabic,
                selected: currentLocale.languageCode == 'ar',
                onTap: () {
                  context.setLocale(const Locale('ar'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return LogoutWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.profile),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<GetProfileViewModel, GetProfileState>(
            builder: (context, state) {
              final profileState = state.getProfileState;

              if (profileState.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (profileState.msg != null) {
                return Center(child: Text(profileState.msg!));
              }

              final driver = profileState.data;

              if (driver == null) {
                return Center(child: Text(AppStrings.noProfileDataAvailable));
              }

              return Column(
                spacing: 30,
                children: [
                  PersonalInformationCard(
                    name: '${driver.firstName} ${driver.lastName}',
                    email: driver.email,
                    phone: driver.phone,
                    photo: driver.photo,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutsName.editProfileScreen,
                      arguments: driver,
                    ),
                  ),
                  VehicleInfoCard(
                    kindOfVehicle: driver.vehicleType,
                    vehicleNumber: driver.vehicleNumber,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutsName.editVehicleInfoScreen,
                      arguments: driver,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () => _showLanguageBottomSheet(context),
                      child: Row(
                        spacing: 10,
                        children: [
                          const Icon(Icons.translate),
                          Text(AppStrings.language, style: TextStyles.bodyRegular13),
                          const Spacer(),
                          Text(
                            context.locale.languageCode == 'ar'
                                ? AppStrings.arabic
                                : AppStrings.english,
                            style: TextStyles.bodyRegularPink11,
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.placeHolder),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () => LogoutDialog.show(
                        context,
                        context.read<LogoutViewModel>(),
                      ),
                      child: Row(
                        spacing: 10,
                        children: [
                          const Icon(Icons.logout),
                          Text(AppStrings.logout, style: TextStyles.bodyRegular13),
                          const Spacer(),
                          const Icon(Icons.logout),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyles.bodyRegular14.copyWith(
                color: selected ? AppColors.pink : AppColors.grey,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(Icons.check_rounded, color: AppColors.pink, size: 20),
          ],
        ),
      ),
    );
  }
}
