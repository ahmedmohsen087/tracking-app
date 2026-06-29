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

  @override
  Widget build(BuildContext context) {
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (profileState.msg != null) {
                return Center(
                  child: Text(profileState.msg!),
                );
              }

              final driver = profileState.data;

              if (driver == null) {
                return Center(
                  child: Text(AppStrings.noProfileDataAvailable),
                );
              }

              return Column(
                spacing: 30,
                children: [
                  PersonalInformationCard(
                    name: '${driver.firstName} ${driver.lastName}',
                    email: driver.email,
                    phone: driver.phone,
                    photo: driver.photo,
                    onTap: () =>
                        Navigator.pushNamed(
                          context,
                          AppRoutsName.editProfileScreen,
                          arguments: driver,
                        ),
                  ),
                  VehicleInfoCard(
                    kindOfVehicle: driver.vehicleType,
                    vehicleNumber: driver.vehicleNumber,
                    onTap: () =>
                        Navigator.pushNamed(
                          context,
                          AppRoutsName.editVehicleInfoScreen,
                          arguments: driver,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      spacing: 10,
                      children: [
                        const Icon(Icons.translate),
                        Text(
                          AppStrings.language,
                          style: TextStyles.bodyRegular13,
                        ),
                        const Spacer(),
                        Text(
                          AppStrings.english,
                          style: TextStyles.bodyRegularPink11,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        LogoutDialog.show(
                          context,
                          context.read<LogoutViewModel>(),
                        );
                      },
                      child: Row(
                        spacing: 10,
                        children: [
                          const Icon(Icons.logout),
                          Text(
                            AppStrings.logout,
                            style: TextStyles.bodyRegular13,
                          ),
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