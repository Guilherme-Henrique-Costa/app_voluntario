import 'package:flutter/material.dart';
import 'package:app_voluntario/core/constants/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final Color? color;
  final Color? textColor;

  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.color = AppColors.primary,
    this.textColor = AppColors.textLight,
  });

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.color = AppColors.textLight,
    this.textColor = AppColors.primary,
  });

  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.color = Colors.transparent,
    this.textColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || loading;

    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: color == Colors.transparent
              ? BorderSide(color: AppColors.primary)
              : BorderSide.none,
        ),
        elevation: color == Colors.transparent ? 0 : 2,
      ),
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
          : Text(
              text,
              style: AppTextStyles.button.copyWith(color: textColor),
            ),
    );
  }
}
