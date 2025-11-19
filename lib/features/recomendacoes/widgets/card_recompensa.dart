import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../core/constants/app_theme.dart';
import '../models/recomendacao_model.dart';

class CardRecompensa extends StatelessWidget {
  final RecompensaProxima recompensa;

  const CardRecompensa({super.key, required this.recompensa});

  @override
  Widget build(BuildContext context) {
    final progresso = (recompensa.progresso.clamp(0, 100)) / 100;

    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recompensa.titulo,
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearPercentIndicator(
              lineHeight: 10,
              percent: progresso,
              backgroundColor: Colors.grey[300],
              progressColor: AppColors.secondary,
              barRadius: const Radius.circular(8),
              animation: true,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${recompensa.progresso}% concluído',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textDark.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
