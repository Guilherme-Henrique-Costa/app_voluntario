import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_theme.dart';
import '../models/vaga_candidatada_model.dart';

class CardVagaCandidatada extends StatelessWidget {
  final VagaCandidatada vaga;
  final VoidCallback onVerDetalhes;
  final VoidCallback onCancelar;

  const CardVagaCandidatada({
    super.key,
    required this.vaga,
    required this.onVerDetalhes,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final data = vaga.dataCandidatura != null
        ? DateFormat('dd/MM/yyyy').format(vaga.dataCandidatura!)
        : 'Data não informada';

    return Card(
      color: AppColors.card,
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

            // Status chip
            _statusChip(vaga.status),

            const SizedBox(height: AppSpacing.sm),

            // Data da candidatura
            Text(
              'Candidatado em: $data',
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Botões de ação
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onCancelar,
                  icon: const Icon(Icons.cancel, color: Colors.red, size: 16),
                  label: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onVerDetalhes,
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Ver Detalhes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Gera um chip colorido conforme o status da candidatura
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
      default:
        cor = Colors.orange;
        label = 'Pendente';
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
