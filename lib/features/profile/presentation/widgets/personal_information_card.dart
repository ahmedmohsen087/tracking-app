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
    final photoUrl = photo ?? '';
    final hasPhoto = photoUrl.isNotEmpty && photoUrl.startsWith('http');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.grey.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.lightPink,
              backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
              child: !hasPhoto
                  ? const Icon(
                      Icons.person,
                      color: AppColors.pink,
                      size: 28,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (name != null && name!.isNotEmpty)
                    Text(
                      name!,
                      style: TextStyles.bodyMedium18.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (email != null && email!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      email!,
                      style: TextStyles.bodyRegular14.copyWith(
                        color: AppColors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (phone != null && phone!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      phone!,
                      style: TextStyles.bodyRegular14.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
