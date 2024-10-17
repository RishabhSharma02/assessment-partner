import 'dart:ui';

import 'package:bhaada_customer_app/Constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [ColorConstants.borderColor, Colors.white.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, 129.w, 191.h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Rect rect = Rect.fromLTWH(0, 0, 129.w, 191.h);
    final RRect rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8.0));

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}