import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class PersonalInformationCard extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? photo;
  final VoidCallback? onTap;

  const PersonalInformationCard({
    super.key,
    this.name,
    this.email,
    this.phone,
    this.photo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
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
                child: Image.network(photo!,
                  fit: BoxFit.cover,
                ),
              ),
            ],),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name!,
              style: TextStyles.bodyMedium18,
            ),
                Text(email!,
                  style: TextStyles.bodyRegular16,),
                Text(phone!,
                  style: TextStyles.bodyRegular16,),

              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios,),



          ],
        ),
      ),
      ),
    );
  }
}
