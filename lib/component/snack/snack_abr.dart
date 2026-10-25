import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

void showFloatingFlushBar(BuildContext context, String title) {
  AnimatedSnackBar.material(
    title,
    type: AnimatedSnackBarType.error,
    mobileSnackBarPosition: MobileSnackBarPosition.top,
    duration: const Duration(seconds: 3),
  ).show(context);
}

void showSuccessFlushBar(BuildContext context, String title) {
  AnimatedSnackBar.material(
    title,
    type: AnimatedSnackBarType.success,
    mobileSnackBarPosition: MobileSnackBarPosition.top,
    duration: const Duration(seconds: 3),
  ).show(context);
}
