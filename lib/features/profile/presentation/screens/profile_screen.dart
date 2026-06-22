
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import '../widgets/personal_information_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profile)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PersonalInformationCard()

          ],
        ),
      ),
    );
  }
}
