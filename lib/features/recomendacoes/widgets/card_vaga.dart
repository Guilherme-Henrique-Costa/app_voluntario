import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import '../models/recomendacao_model.dart';
import '../../vagas/pages/tela_detalhe_vaga.dart';

class CardVaga extends StatelessWidget {
  final VagaRecomendada vaga;

  const CardVaga({super.key, required this.vaga});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vaga.titulo,
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Causa: ${vaga.causa}',
              style: AppTextStyles.body,
            ),
            Text(
              'Local: ${vaga.localidade}',
              style: AppTextStyles.body,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TelaDetalheVaga(vaga: vaga),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward_ios, size: 14),
                label: const Text('Ver mais'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
