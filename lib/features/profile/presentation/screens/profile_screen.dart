import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/view_models/logout_view_model/logout_view_model.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_driver_entity.dart';
import '../view_models/get_profile_view_model/get_profile_event.dart';
import '../view_models/get_profile_view_model/get_profile_state.dart';
import '../view_models/get_profile_view_model/get_profile_view_model.dart';
import '../widgets/logout_widget.dart';
import '../widgets/personal_information_card.dart';
import '../widgets/vehicle_info_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _LanguageBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale;

    return LogoutWidget(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AppStrings.profile,
              style: TextStyles.appBarTextStyle,
            ),
          ),
        ),
        body: SafeArea(
          child: _ProfileBodyContent(
            onOpenLanguage: () => _showLanguageBottomSheet(context),
          ),
        ),
      ),
    );
  }
}

class _ProfileBodyContent extends StatelessWidget {
  const _ProfileBodyContent({required this.onOpenLanguage});

  final VoidCallback onOpenLanguage;

  Future<void> _onEditProfile(
      BuildContext context, ProfileDriverEntity driver) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutsName.editProfileScreen,
      arguments: driver,
    );
    if (result == true && context.mounted) {
      context
          .read<GetProfileViewModel>()
          .doEvent(const RefreshProfileEvent());
    }
  }

  Future<void> _onEditVehicle(
      BuildContext context, ProfileDriverEntity driver) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutsName.editVehicleInfoScreen,
      arguments: driver,
    );
    if (result == true && context.mounted) {
      context
          .read<GetProfileViewModel>()
          .doEvent(const RefreshProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProfileViewModel, GetProfileState>(
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

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              PersonalInformationCard(
                name: '${driver.firstName} ${driver.lastName}'.trim(),
                email: driver.email,
                phone: driver.phone,
                photo: driver.photo,
                onTap: () => _onEditProfile(context, driver),
              ),
              const SizedBox(height: 16),
              VehicleInfoCard(
                kindOfVehicle: driver.vehicleType,
                vehicleNumber: driver.vehicleNumber,
                onTap: () => _onEditVehicle(context, driver),
              ),
              const SizedBox(height: 24),
              _LanguageRowTile(onTap: onOpenLanguage),
              const SizedBox(height: 8),
              const _LogoutRowTile(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageRowTile extends StatelessWidget {
  const _LanguageRowTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            const Icon(
              Icons.translate_rounded,
              color: AppColors.black,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              AppStrings.language,
              style: TextStyles.bodyRegular14.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              langCode == 'ar' ? AppStrings.arabic : AppStrings.english,
              style: TextStyles.bodyRegularPink11.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutRowTile extends StatelessWidget {
  const _LogoutRowTile();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => LogoutDialog.show(
        context,
        context.read<LogoutViewModel>(),
      ),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            const Icon(
              Icons.logout_rounded,
              color: AppColors.black,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              AppStrings.logout,
              style: TextStyles.bodyRegular14.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.exit_to_app_rounded,
              color: AppColors.grey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageBottomSheet extends StatelessWidget {
  const _LanguageBottomSheet();

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.language,
            style: TextStyles.bodyMedium18.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          _LanguageOption(
            label: AppStrings.english,
            selected: currentLocale.languageCode == 'en',
            onTap: () {
              context.setLocale(const Locale('en'));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
          _LanguageOption(
            label: AppStrings.arabic,
            selected: currentLocale.languageCode == 'ar',
            onTap: () {
              context.setLocale(const Locale('ar'));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
        ],
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
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.lightPink : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.pink
                : AppColors.grey.withValues(alpha: 0.2),
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyles.bodyRegular14.copyWith(
                color: selected ? AppColors.pink : AppColors.black,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.pink,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
