
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/text_styles.dart';
import '../widgets/personal_information_card.dart';
import '../widgets/vehicle_info_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profile)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 30,
          children: [
            PersonalInformationCard(),
            VehicleInfoCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 10,
                children: [
                  Icon(Icons.translate,),
                  Text(AppStrings.language,
                    style: TextStyles.bodyRegular13,
                  ),
                  Spacer(),
                  Text(AppStrings.english,
                    style: TextStyles.bodyRegularPink11,)



              ],),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 10,
                children: [
                  Icon(Icons.logout,),
                  Text(AppStrings.language,
                    style: TextStyles.bodyRegular13,
                  ),
                  Spacer(),
                  Icon(Icons.logout,),



                ],),
            ),

          ],
        ),
      ),
    );
  }
}
