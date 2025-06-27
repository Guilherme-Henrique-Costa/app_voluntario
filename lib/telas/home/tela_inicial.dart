import 'package:app_voluntario/models/recompensa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../vagas/tela_detalhe_vaga.dart';
import '../recompensa/tela_recompensa.dart';

class TelaInicial extends StatelessWidget {
  final vagas = [
    {
      'titulo': 'Apoio em Eventos Comunitários',
      'cargo': 'Organizador de Evento',
      'localidade': 'Quadra 301 Norte',
      'descricao':
          'Auxiliar na organização de eventos sociais, recepção do público e montagem de estrutura.',
      'instituicao': 'Cruz Vermelha',
      'data': '2025-07-01',
      'especificacoes': ['Pontualidade', 'Boa comunicação'],
      'status': 'Disponível',
    },
    {
      'titulo': 'Voluntário de Comunicação',
      'cargo': 'Redator de Conteúdo',
      'localidade': 'Centro Cultural',
      'descricao':
          'Apoio com textos para redes sociais e envio de e-mails informativos sobre ações sociais.',
      'instituicao': 'ONG Jovem Ação',
      'data': '2025-07-10',
      'especificacoes': [
        'Criatividade',
        'Conhecimento básico em redes sociais'
      ],
      'status': 'Disponível',
    },
  ];

  final Map<String, dynamic> feedback = {
    'nota': 5,
    'comentario': 'Trabalho excelente!\nAjudou a reestruturar nosso sistema.',
    'autor': 'Fulano',
    'data': '12/09/2025'
  };

  final List<Recompensa> recompensas = [
    Recompensa(
      titulo: 'Voluntário do Mês',
      descricao: 'Por dedicação contínua às causas sociais',
      data: DateTime(2025, 6, 5),
    ),
    Recompensa(
      titulo: 'Missão Cumprida',
      descricao: 'Finalizou todas as tarefas com excelência',
      data: DateTime(2025, 6, 10),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final vagasResumo = vagas.take(2).toList();
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Olá, voluntário!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white),
                    onPressed: () => Navigator.pushNamed(context, '/perfil'),
                  )
                ],
              ),
              SizedBox(height: 30),
              GridView.count(
                crossAxisCount: largura > 600 ? 4 : 2,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildAtalho(context, Icons.work, 'Vagas', '/vagas'),
                  _buildAtalho(
                      context, Icons.calendar_today, 'Agenda', '/agenda'),
                  _buildAtalho(
                      context, Icons.message, 'Mensagens', '/mensagens'),
                  _buildAtalho(context, Icons.emoji_events, 'Recompensas',
                      '/recompensa'),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('Vagas em Destaque',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
              SizedBox(height: 10),
              ...vagasResumo.map((vaga) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: ListTile(
                      title: Text(vaga['titulo'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(vaga['descricao'].toString()),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TelaDetalheVaga(vaga: vaga),
                          ),
                        );
                      },
                    ),
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/vagas'),
                  child: Text('Ver todas as vagas →',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              Divider(color: Colors.white70),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.card_giftcard, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('Suas Recompensas',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
              SizedBox(height: 10),
              ...recompensas.take(2).map((r) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.emoji_events,
                          color: Colors.amber[700], size: 32),
                      title: Text(r.titulo,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '${r.descricao}\nRecebida em: ${DateFormat('dd/MM/yyyy').format(r.data)}',
                      ),
                      isThreeLine: true,
                    ),
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/recompensa'),
                  child: Text('Ver todas →',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              Divider(color: Colors.white70),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.feedback, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('Feedback',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
              SizedBox(height: 10),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      feedback['nota'] as int,
                      (index) =>
                          Icon(Icons.star, color: Colors.orange, size: 16),
                    ),
                  ),
                  title: Text(feedback['comentario']),
                  subtitle: Text('${feedback['autor']} - ${feedback['data']}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAtalho(
      BuildContext context, IconData icone, String texto, String rota) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, rota),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 36, color: Colors.deepPurple[800]),
            SizedBox(height: 10),
            Text(texto,
                style: TextStyle(fontSize: 16, color: Colors.deepPurple[800])),
          ],
        ),
      ),
    );
  }
}
