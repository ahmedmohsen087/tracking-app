import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_models/get_profile_view_model/get_profile_state.dart';
import '../view_models/get_profile_view_model/get_profile_view_model.dart';
import '../widgets/personal_information_card.dart';
import '../widgets/vehicle_info_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                  ],
                ),
              );
            }

            final driver = profileState.data;

            if (driver == null) {
              return  Center(
                child: Text(AppStrings.noProfileDataAvailable),
              );
            }

            return Column(
              spacing: 30,
              children: [
                PersonalInformationCard(
                  name:
                  '${driver.firstName } ${driver.lastName }',
                  email: driver.email,
                  phone: driver.phone,
                  photo: driver.photo  ,
                ),
                VehicleInfoCard(
                  kindOfVehicle: driver.vehicleType ,
                  vehicleNumber: driver.vehicleNumber ,
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
              ],
            );
          },
        ),
      ),
    );
  }
}