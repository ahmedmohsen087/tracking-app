import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class AddressItem extends StatelessWidget {
  const AddressItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
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
      child: Row(
        spacing: 20,
        children: [
          CircleAvatar(
            child: Image.asset('assets/images/Photo.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Flowery store',
              style: TextStyles.bodyRegular13.copyWith(
                color: AppColors.grey
              ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  Text('20th st, Sheikh Zayed, Giza ',
                    style: TextStyles.bodyRegular13,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
