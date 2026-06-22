import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class PersonalInformationCard extends StatelessWidget {
  const PersonalInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],


      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              CircleAvatar(
                child: Image.asset('assets/images/Photo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('John Doe',
              style: TextStyles.bodyMedium18,
            ),
                Text('John Doe@gmail.com',
                  style: TextStyles.bodyRegular16,),
                Text('012113456789',
                  style: TextStyles.bodyRegular16,),

              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios,),



          ],
        ),
      ),
    );
  }
}
