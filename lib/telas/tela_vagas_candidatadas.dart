import 'package:flutter/material.dart';

class TelaVagasCandidatadas extends StatelessWidget {
  final List<String> vagasCandidatadas = [
    'Apoio em Eventos Comunitários',
    'Voluntário de Comunicação',
    'Monitor em Atividades Esportivas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vagas Candidatadas'),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: vagasCandidatadas.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(
              vagasCandidatadas[index],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Status: Candidatado'),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
        ),
      ),
    );
  }
}
