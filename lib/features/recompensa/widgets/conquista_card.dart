import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_theme.dart';
import '../models/conquista.dart';

class ConquistaCard extends StatelessWidget {
  final Conquista conquista;

  const ConquistaCard({super.key, required this.conquista});

  @override
  Widget build(BuildContext context) {
    final corProgresso =
        conquista.concluido ? AppColors.success : AppColors.primary;

    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            conquista.concluido
                ? Lottie.asset(
                    'assets/animations/confetti.json',
                    width: 60,
                    height: 60,
                    repeat: false,
                  )
                : Icon(Icons.star_border, color: corProgresso, size: 50),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(conquista.titulo, style: AppTextStyles.title),
                  const SizedBox(height: AppSpacing.xs),
                  Text(conquista.descricao, style: AppTextStyles.body),
                  const SizedBox(height: AppSpacing.sm),
                  LinearProgressIndicator(
                    value: conquista.progresso,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(corProgresso),
                    minHeight: 6,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${(conquista.progresso * 100).toInt()}% concluído',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
