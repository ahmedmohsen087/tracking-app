import 'dart:io';

import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/values/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileAvatarWidget extends StatelessWidget {
  const ProfileAvatarWidget({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  final String? imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.whiteGrey,
            backgroundImage: imagePath != null
                ? FileImage(File(imagePath!))
                : null,
            child: imagePath == null
                ? SvgPicture.asset(
                    Assets.assetsIconsPerson,
                    width: 48,
                    height: 48,
                    colorFilter: const ColorFilter.mode(
                      AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.pink,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  Assets.assetsIconsPhotoCamera,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
