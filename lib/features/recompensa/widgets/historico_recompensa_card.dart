import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_theme.dart';
import '../models/recompensa.dart';

class HistoricoRecompensaCard extends StatelessWidget {
  final Recompensa recompensa;

  const HistoricoRecompensaCard({super.key, required this.recompensa});

  @override
  Widget build(BuildContext context) {
    final data = DateFormat('dd/MM/yyyy').format(recompensa.data);

    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.emoji_events,
            color: AppColors.secondary, size: 36),
        title: Text(recompensa.titulo, style: AppTextStyles.title),
        subtitle: Text(
          '${recompensa.descricao}\nRecebida em: $data',
          style: AppTextStyles.body,
        ),
        isThreeLine: true,
      ),
    );
  }
}
