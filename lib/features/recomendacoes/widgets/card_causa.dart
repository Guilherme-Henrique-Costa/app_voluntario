import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import '../models/recomendacao_model.dart';

class CardCausa extends StatelessWidget {
  final CausaEngajada causa;

  const CardCausa({super.key, required this.causa});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            const Icon(Icons.favorite, color: AppColors.secondary, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                causa.causa,
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${causa.participacoes} participações',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textDark.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
