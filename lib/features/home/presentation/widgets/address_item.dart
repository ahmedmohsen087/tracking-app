import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/api_endpoints.dart';
import '../../../../core/values/assets.dart';

class AddressItem extends StatelessWidget {
  final String? title;
  final String? address;
  final String? image;

  const AddressItem({super.key, this.title, this.address, this.image});

  @override
  Widget build(BuildContext context) {
    final fullImageUrl = ApiEndpoints.imageUrl(image);

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.lightPink,
            backgroundImage:
                fullImageUrl.isNotEmpty ? NetworkImage(fullImageUrl) : null,
            child: fullImageUrl.isEmpty
                ? SvgPicture.asset(
                    Assets.assetsIconsPerson,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.pink,
                      BlendMode.srcIn,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.bodyRegular13.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      child: Icon(Icons.location_on_outlined, size: 18),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.bodyRegular12.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
