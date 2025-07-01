import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/recompensa.dart';

class TelaHistoricoRecompensas extends StatelessWidget {
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
      appBar: AppBar(
        title: Text(
          'Histórico de Recompensas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: historico.length,
        itemBuilder: (context, index) {
          final r = historico[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading:
                  Icon(Icons.emoji_events, color: Colors.amber[700], size: 36),
              title:
                  Text(r.titulo, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                '${r.descricao}\nRecebida em: ${DateFormat('dd/MM/yyyy').format(r.data)}',
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
