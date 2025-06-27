import 'package:flutter/material.dart';
import 'tela_detalhe_vaga.dart'; // Certifique-se de que esse arquivo existe

class TelaVagas extends StatelessWidget {
  final List<Map<String, dynamic>> vagasDisponiveis = [
    {
      'titulo': 'Aula de Reforço Escolar',
      'cargo': 'Professor Voluntário',
      'localidade': 'Escola Municipal Zumbi',
      'descricao': 'Ensinar crianças do ensino fundamental.',
      'especificacoes': ['Didática', 'Conhecimento em matemática e português'],
      'data': '2025-07-20',
      'status': 'Disponível',
      'instituicao': 'EducaMais ONG'
    },
    {
      'titulo': 'Campanha de Arrecadação de Agasalhos',
      'cargo': 'Organizador de Campanha',
      'localidade': 'Praça Central',
      'descricao': 'Auxiliar na coleta e separação de roupas.',
      'especificacoes': ['Organização', 'Boa comunicação'],
      'data': '2025-08-05',
      'status': 'Disponível',
      'instituicao': 'Voluntários do Bem'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vagas Disponíveis'),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: ListView.builder(
        itemCount: vagasDisponiveis.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final vaga = vagasDisponiveis[index];

          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(vaga['titulo']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cargo: ${vaga['cargo']}'),
                  Text('Local: ${vaga['localidade']}'),
                  Text('Instituição: ${vaga['instituicao']}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaDetalheVaga(vaga: vaga),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
