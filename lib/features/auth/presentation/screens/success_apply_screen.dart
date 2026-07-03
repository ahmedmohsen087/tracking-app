import 'package:flowery_rider_app/core/theme/app_colors.dart';
import 'package:flowery_rider_app/core/theme/text_styles.dart';
import 'package:flowery_rider_app/core/values/app_routs_name.dart';
import 'package:flowery_rider_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

class SuccessApplyScreen extends StatelessWidget {
  const SuccessApplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _WaveDecoration(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),
                  const _CheckCircleIcon(),
                  const SizedBox(height: 32),
                  Text(
                    AppStrings.applicationSubmitted,
                    style: TextStyles.bodyMedium18.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.applicationSubmittedSubtitle,
                    style: TextStyles.bodyRegular14.copyWith(
                      color: AppColors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _LoginButton(context: context),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckCircleIcon extends StatelessWidget {
  const _CheckCircleIcon();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.pink, width: 3),
        ),
        child: const Icon(Icons.check, color: AppColors.pink, size: 64),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final BuildContext context;

  const _LoginButton({required this.context});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutsName.loginScreen, (route) => false),
        child: Text(AppStrings.login),
      ),
    );
  }
}

class _WaveDecoration extends StatefulWidget {
  const _WaveDecoration();

  @override
  State<_WaveDecoration> createState() => _WaveDecorationState();
}

class _WaveDecorationState extends State<_WaveDecoration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WavePainter(animationValue: _controller.value),
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animationValue;

  _WavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.pink.withValues(alpha: 0.15);

    final shift = animationValue * size.width;

    canvas.save();
    canvas.translate(-shift, 0);

    final width = size.width;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.5);
    path1.quadraticBezierTo(
      width * 0.25,
      size.height * 0.2,
      width * 0.5,
      size.height * 0.5,
    );
    path1.quadraticBezierTo(
      width * 0.75,
      size.height * 0.8,
      width,
      size.height * 0.5,
    );
    path1.quadraticBezierTo(
      width * 1.25,
      size.height * 0.2,
      width * 1.5,
      size.height * 0.5,
    );
    path1.quadraticBezierTo(
      width * 1.75,
      size.height * 0.8,
      width * 2,
      size.height * 0.5,
    );
    path1.lineTo(width * 2, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint);

    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.pink.withValues(alpha: 0.25);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    path2.quadraticBezierTo(
      width * 0.25,
      size.height * 0.8,
      width * 0.5,
      size.height * 0.6,
    );
    path2.quadraticBezierTo(
      width * 0.75,
      size.height * 0.4,
      width,
      size.height * 0.6,
    );
    path2.quadraticBezierTo(
      width * 1.25,
      size.height * 0.8,
      width * 1.5,
      size.height * 0.6,
    );
    path2.quadraticBezierTo(
      width * 1.75,
      size.height * 0.4,
      width * 2,
      size.height * 0.6,
    );
    path2.lineTo(width * 2, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
