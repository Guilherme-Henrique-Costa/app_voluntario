import 'package:flutter/material.dart';

class TelaHistorico extends StatelessWidget {
  final List<Map<String, String>> vagasVoluntariadas = [
    {
      'titulo': 'Distribuição de Alimentos',
      'descricao': 'Ajuda na entrega de cestas básicas.',
      'data': '10/05/2025'
    },
    {
      'titulo': 'Campanha de Doação de Sangue',
      'descricao': 'Auxílio na organização da fila e triagem.',
      'data': '22/04/2025'
    },
    {
      'titulo': 'Mutirão de Limpeza',
      'descricao': 'Limpeza de praça e plantio de mudas.',
      'data': '15/03/2025'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Voluntariado'),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: vagasVoluntariadas.length,
        itemBuilder: (context, index) {
          final vaga = vagasVoluntariadas[index];
          return Card(
            child: ListTile(
              title: Text(vaga['titulo'] ?? ''),
              subtitle: Text(vaga['descricao'] ?? ''),
              trailing: Text(vaga['data'] ?? ''),
            ),
          );
        },
      ),
    );
  }
}
