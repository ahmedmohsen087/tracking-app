import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppDialog {
  AppDialog._();

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String description,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    SvgPicture? icon,
    bool barrierDismissible = true,
    bool buttonsVertical = false,
    Color confirmButtonColor = AppColors.pink,
    Color cancelButtonColor = AppColors.white,
    Color confirmTextColor = AppColors.white,
    Color cancelTextColor = AppColors.black,
    bool isCancelOutlined = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon, const SizedBox(height: 18)],
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyMedium18.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyRegular14.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 28),
                if (buttonsVertical)
                  Column(
                    children: [
                      if (confirmText != null)
                        _DialogButton(
                          text: confirmText,
                          backgroundColor: confirmButtonColor,
                          textColor: confirmTextColor,
                          isOutlined: false,
                          onPressed: () {
                            Navigator.pop(context);
                            onConfirm?.call();
                          },
                        ),
                      if (confirmText != null && cancelText != null)
                        const SizedBox(height: 12),
                      if (cancelText != null)
                        _DialogButton(
                          text: cancelText,
                          backgroundColor: cancelButtonColor,
                          textColor: cancelTextColor,
                          isOutlined: isCancelOutlined,
                          onPressed: () {
                            Navigator.pop(context);
                            onCancel?.call();
                          },
                        ),
                    ],
                  )
                else
                  Row(
                    children: [
                      if (cancelText != null)
                        Expanded(
                          child: _DialogButton(
                            text: cancelText,
                            backgroundColor: cancelButtonColor,
                            textColor: cancelTextColor,
                            isOutlined: isCancelOutlined,
                            onPressed: () {
                              Navigator.pop(context);
                              onCancel?.call();
                            },
                          ),
                        ),
                      if (confirmText != null && cancelText != null)
                        const SizedBox(width: 12),
                      if (confirmText != null)
                        Expanded(
                          child: _DialogButton(
                            text: confirmText,
                            backgroundColor: confirmButtonColor,
                            textColor: confirmTextColor,
                            isOutlined: false,
                            onPressed: () {
                              Navigator.pop(context);
                              onConfirm?.call();
                            },
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutlined;

  const _DialogButton({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.grey.withValues(alpha: 0.4),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                text,
                style: TextStyles.bodyRegular14.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                text,
                style: TextStyles.bodyRegular14.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
