import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';

class NenhumaConquista extends StatelessWidget {
  const NenhumaConquista({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.emoji_emotions_outlined,
                color: AppColors.primary, size: 80),
            SizedBox(height: AppSpacing.md),
            Text(
              'Nenhuma conquista encontrada.',
              style: AppTextStyles.subtitle,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Participe de ações voluntárias para desbloquear conquistas!',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
