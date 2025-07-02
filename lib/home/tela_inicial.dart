import 'package:app_voluntario/features/mensagens/models/conversa.dart';
import 'package:app_voluntario/features/vagas/models/vaga_instituicao_model.dart';
import 'package:app_voluntario/features/vagas/services/vaga_instituicao_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_voluntario/features/recompensa/models/recompensa.dart';
import 'package:app_voluntario/features/feedback/models/feedback.dart';
import 'package:app_voluntario/features/feedback/services/feedback_service.dart';
import 'package:app_voluntario/core/constants/storage_service.dart';
import '../features/vagas/pages/tela_detalhe_vaga.dart';
import '../features/recompensa/pages/tela_recompensa.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
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

  List<VagaInstituicao> vaga = [];
  List<Recompensa> recompensa = [];
  List<FeedbackModel> feedbacks = [];

  @override
  void initState() {
    super.initState();
    _carregarFeedbacks();
    carregarVagas();
  }

  Future<void> _carregarFeedbacks() async {
    final lista = await FeedbackService.listarFeedbacks();
    setState(() {
      feedbacks = lista.reversed.toList();
    });
  }

  Future<void> carregarVagas() async {
    final lista = await VagaInstituicaoService().listarVagasDisponiveis();
    setState(() => vaga = lista);
  }

  @override
  Widget build(BuildContext context) {
    final vagasResumo = vaga.take(2).toList();
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
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
                  _buildAtalho(context, Icons.emoji_events, 'Recompensas',
                      '/recompensa'),
                  _buildAtalho(
                      context, Icons.feedback, 'Feedback', '/feedback'),
                  _buildAtalho(context, Icons.feedback_outlined,
                      'Todos os Feedbacks', '/feedbacks'),
                  _buildAtalho(
                      context, Icons.list_alt, 'Minhas Vagas', '/minhas_vagas'),
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
                      title: Text(
                        vaga.cargo,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(vaga.descricao),
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
                  Text('Feedbacks',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
              SizedBox(height: 10),
              ...feedbacks.take(2).map((f) => AnimatedContainer(
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
                      leading:
                          Icon(Icons.feedback, color: Colors.deepPurple[800]),
                      title: Text(f.mensagem),
                      subtitle:
                          Text(DateFormat('dd/MM/yyyy – HH:mm').format(f.data)),
                    ),
                  )),
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
                style: TextStyle(fontSize: 16, color: Colors.deepPurple[800]))
          ],
        ),
      ),
    );
  }
}
