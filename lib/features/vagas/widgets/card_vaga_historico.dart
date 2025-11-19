import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_theme.dart';
import '../models/vaga_candidatada_model.dart';

class CardVagaHistorico extends StatelessWidget {
  final VagaCandidatada vaga;

  const CardVagaHistorico({super.key, required this.vaga});

  @override
  Widget build(BuildContext context) {
    final data = vaga.dataCandidatura != null
        ? DateFormat('dd/MM/yyyy').format(vaga.dataCandidatura!)
        : 'Data não informada';

    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cargo
            Text(
              vaga.cargo,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: AppSpacing.xs),

            // Instituição
            Text(
              vaga.instituicao.nome,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Localização
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: AppColors.secondary, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    vaga.localidade,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[800]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Chip de status
            _statusChip(vaga.status),

            const SizedBox(height: AppSpacing.sm),

            // Data da candidatura
            Text(
              'Data da candidatura: $data',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  /// Gera um chip colorido conforme o status da vaga
  Widget _statusChip(String? status) {
    final texto = status?.trim().toLowerCase() ?? 'pendente';

    Color cor;
    String label;

    switch (texto) {
      case 'aprovado':
        cor = AppColors.success;
        label = 'Aprovado';
        break;
      case 'rejeitado':
        cor = AppColors.error;
        label = 'Rejeitado';
        break;
      case 'pendente':
        cor = Colors.orange;
        label = 'Pendente';
        break;
      default:
        cor = Colors.grey;
        label = 'Desconhecido';
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        backgroundColor: cor,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
