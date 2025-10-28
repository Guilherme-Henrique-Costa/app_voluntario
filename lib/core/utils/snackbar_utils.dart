import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class SnackBarUtils {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, backgroundColor: AppColors.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, backgroundColor: AppColors.error);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, backgroundColor: AppColors.secondary);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, message, backgroundColor: Colors.orangeAccent);
  }

  static void _show(BuildContext context, String message,
      {required Color backgroundColor}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
