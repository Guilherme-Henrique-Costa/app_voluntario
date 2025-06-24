import 'package:flutter/material.dart';
import '../componentes/cartao_vaga.dart';

class TelaInicial extends StatelessWidget {
  final vagas = [
    {
      'titulo': 'Apoio em Eventos Comunitários',
      'descricao':
          'Auxiliar na organização de eventos sociais, recepção do público e montagem de estrutura.'
    },
    {
      'titulo': 'Voluntário de Comunicação',
      'descricao':
          'Apoio com textos para redes sociais e envio de e-mails informativos sobre ações sociais.'
    },
    {
      'titulo': 'Monitor em Atividades Esportivas',
      'descricao':
          'Acompanhar crianças e jovens em atividades esportivas e de lazer.'
    },
  ];

  final Map<String, dynamic> feedback = {
    'nota': 5,
    'comentario': 'Trabalho excelente!\nAjudou a reestruturar nosso sistema.',
    'autor': 'Fulano',
    'data': '12/09/2025'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[900],
        title: Text('Vagas'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pushNamed(context, '/perfil');
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Vagas'),
              onTap: () {
                Navigator.pushNamed(context, '/vagas_candidatadas');
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Mensagens'),
              onTap: () {
                Navigator.pushNamed(context, '/mensagens');
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Agenda'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/agenda');
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Histórico'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/historico');
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.deepPurple[900],
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ...vagas.map((vaga) => Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    vaga['titulo']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(vaga['descricao']!),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Ação ao se candidatar
                    },
                    child: Text('Candidatar'),
                  ),
                ),
              )),
          SizedBox(height: 20),
          Text(
            'Feedback',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 10),
          Card(
            color: Colors.white,
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  feedback['nota'] as int,
                  (index) => Icon(Icons.star, color: Colors.orange, size: 16),
                ),
              ),
              title: Text(feedback['comentario'] as String),
              subtitle: Text('${feedback['autor']} - ${feedback['data']}'),
            ),
          ),
        ],
      ),
    );
  }
}
