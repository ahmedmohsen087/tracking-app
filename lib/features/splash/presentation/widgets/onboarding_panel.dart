import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPanel extends StatelessWidget {
  const OnboardingPanel({
    super.key,
    required this.opacity,
    required this.translateY,
    required this.onLogin,
    required this.onApplyNow,
  });

  final double opacity;
  final double translateY;
  final VoidCallback onLogin;
  final VoidCallback onApplyNow;

  static const _outlineColor = Color(0xffE4E0E2);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, translateY),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.welcomeToFloweryRiderApp,
                  style: GoogleFonts.poppins(
                    fontSize: 23,
                    height: 1.32,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 26),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pink.withValues(alpha: 0.6),
                        blurRadius: 24,
                        spreadRadius: -10,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: onLogin,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.pink,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Text(AppStrings.login),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: onApplyNow,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.black,
                      side: const BorderSide(color: _outlineColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(AppStrings.applyNow),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
