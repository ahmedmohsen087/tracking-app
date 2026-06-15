import 'package:flutter/material.dart';

class CircularRevealClipper extends CustomClipper<Path> {
  const CircularRevealClipper({required this.progress});

  final double progress;

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = Offset(size.width, size.height).distance / 2;
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: maxRadius * progress));
  }

  @override
  bool shouldReclip(covariant CircularRevealClipper oldClipper) =>
      oldClipper.progress != progress;
}
