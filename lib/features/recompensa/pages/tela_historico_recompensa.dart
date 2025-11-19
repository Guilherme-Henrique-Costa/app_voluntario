import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_theme.dart';
import '../models/recompensa.dart';
import '../widgets/historico_recompensa_card.dart';

class TelaHistoricoRecompensas extends StatelessWidget {
  TelaHistoricoRecompensas({super.key});

  final List<Recompensa> historico = [
    Recompensa(
      titulo: 'Voluntário do Mês',
      descricao: 'Destaque em ações sociais.',
      data: DateTime(2025, 6, 5),
    ),
    Recompensa(
      titulo: 'Missão Cumprida',
      descricao: 'Finalizou todas as tarefas.',
      data: DateTime(2025, 6, 10),
    ),
    Recompensa(
      titulo: 'Ajudante Rápido',
      descricao: 'Ajudou prontamente quando solicitado.',
      data: DateTime(2025, 6, 20),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Recompensas')),
      body: historico.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma recompensa encontrada.',
                style: AppTextStyles.body,
              ),
            )
          : ListView.builder(
              itemCount: historico.length,
              itemBuilder: (context, index) {
                final recompensa = historico[index];
                return HistoricoRecompensaCard(recompensa: recompensa);
              },
            ),
    );
  }
}
