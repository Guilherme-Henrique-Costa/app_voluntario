import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'package:app_voluntario/features/mensagens/models/conversa.dart';
import 'package:app_voluntario/features/vagas/models/vaga_instituicao_model.dart';
import 'package:app_voluntario/features/vagas/services/vaga_instituicao_service.dart';
import 'package:app_voluntario/features/recompensa/models/recompensa.dart';
import 'package:app_voluntario/features/feedback/models/feedback_model.dart';
import 'package:app_voluntario/features/feedback/services/feedback_service.dart';
import 'package:app_voluntario/features/vagas/pages/tela_detalhe_vaga.dart';
import 'package:app_voluntario/core/constants/storage_service.dart';
import 'package:app_voluntario/features/recomendacoes/models/recomendacao_model.dart';
import 'package:app_voluntario/features/recomendacoes/services/recomendacao_service.dart';
import 'package:app_voluntario/features/dashboard/pages/tela_dashboard.dart';
import 'package:app_voluntario/features/recomendacoes/pages/tela_recomendacoes.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  String? nomeUsuario;
  Future<RecomendacaoModel>? _futureRecomendacoes;

  Future<void> _carregarUsuario() async {
    final nome = await StorageService.getUserName();
    setState(() => nomeUsuario = nome ?? 'Voluntário');
  }

  void _carregarRecomendacoes() async {
    final voluntario = await StorageService.obterAtual();
    if (voluntario != null && voluntario.id != null) {
      setState(() {
        _futureRecomendacoes =
            RecomendacaoService().fetchRecomendacoes(voluntario.id!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
    _carregarRecomendacoes();
  }

  Future<void> _recarregarDados() async {
    setState(() => nomeUsuario = null);
    await _carregarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _recarregarDados,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Olá, $nomeUsuario!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/perfil'),
                      ),
                    ],
                  ),
                ),
              ),
              _buildGridAtalhos(context, largura),
              _buildRecomendacoesSection(),
              _buildVagasSection(),
              _buildRecompensasSection(),
              _buildFeedbacksSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridAtalhos(BuildContext context, double largura) {
    final atalhos = [
      _buildAtalho(context, Icons.work, 'Vagas', '/vagas'),
      _buildAtalho(context, Icons.calendar_today, 'Agenda', '/agenda'),
      _buildAtalho(context, Icons.emoji_events, 'Recompensas', '/recompensa'),
      _buildAtalho(context, Icons.feedback, 'Feedback', '/feedback'),
      _buildAtalho(
          context, Icons.feedback_outlined, 'Todos os Feedbacks', '/feedbacks'),
      _buildAtalho(context, Icons.list_alt, 'Minhas Vagas', '/minhas_vagas'),
      _buildAtalho(context, Icons.bar_chart, 'Estatísticas', '/dashboard'),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid.count(
        crossAxisCount: largura > 600 ? 4 : 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
        children: atalhos,
      ),
    );
  }

  Widget _buildAtalho(
      BuildContext context, IconData icone, String texto, String rota) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, rota),
      child: Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 36, color: Colors.deepPurple[800]),
            const SizedBox(height: 10),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecomendacoesSection() {
    if (_futureRecomendacoes == null) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder<RecomendacaoModel>(
      future: _futureRecomendacoes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return const SliverToBoxAdapter(
              child: Center(child: Text('Erro ao carregar recomendações.')));
        } else if (!snapshot.hasData) {
          return const SliverToBoxAdapter(
              child: Center(child: Text('Nenhuma recomendação disponível.')));
        }

        final dados = snapshot.data!;
        final vagas = dados.vagasRecomendadas.take(2).toList();
        final recompensas = dados.recompensasProximas.take(1).toList();
        final causas = dados.causasMaisEngajadas.take(1).toList();

        return _buildCardSection(
          context,
          icon: Icons.recommend,
          title: 'Recomendações Inteligentes',
          children: [
            ...vagas.map((v) => ListTile(
                  title: Text(v.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${v.causa} • ${v.localidade}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                )),
            ...recompensas.map((r) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.titulo,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    LinearPercentIndicator(
                      lineHeight: 10,
                      percent: r.progresso / 100,
                      backgroundColor: Colors.grey[300],
                      progressColor: Colors.amber,
                      animation: true,
                      barRadius: const Radius.circular(6),
                    ),
                    const SizedBox(height: 8),
                  ],
                )),
            ...causas.map((c) => ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.pink),
                  title: Text(c.causa),
                  trailing: Text('${c.participacoes}x'),
                )),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/recomendacoes'),
                child: const Text('Ver todas →',
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildVagasSection() {
    return FutureBuilder<List<VagaInstituicao>>(
      future: VagaInstituicaoService().listarVagasDisponiveis(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return const SliverToBoxAdapter(
              child: Center(child: Text('Erro ao carregar vagas.')));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
              child: Center(child: Text('Nenhuma vaga disponível.')));
        }

        final vagas = snapshot.data!.take(2).toList();

        return _buildCardSection(
          context,
          icon: Icons.star,
          title: 'Vagas em Destaque',
          children: [
            ...vagas.map((v) => _CardVaga(vaga: v)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/vagas'),
                child: const Text('Ver todas as vagas →',
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  SliverToBoxAdapter _buildRecompensasSection() {
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

    return _buildCardSection(
      null,
      icon: Icons.card_giftcard,
      title: 'Suas Recompensas',
      children: [
        ...recompensas.map((r) => _CardRecompensa(recompensa: r)),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => {},
            child: const Text('Ver todas →',
                style: TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }

  Widget _buildFeedbacksSection() {
    return FutureBuilder<List<FeedbackModel>>(
      future: FeedbackService.listarFeedbacks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return const SliverToBoxAdapter(
              child: Center(child: Text('Erro ao carregar feedbacks.')));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
              child: Center(child: Text('Nenhum feedback disponível.')));
        }

        final feedbacks = snapshot.data!.reversed.take(2).toList();

        return _buildCardSection(
          context,
          icon: Icons.feedback,
          title: 'Feedbacks',
          children: feedbacks.map((f) => _CardFeedback(feedback: f)).toList(),
        );
      },
    );
  }

  SliverToBoxAdapter _buildCardSection(BuildContext? context,
      {required IconData icon,
      required String title,
      required List<Widget> children}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.amber),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 10),
            ...children,
            const Divider(color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _CardVaga extends StatelessWidget {
  final VagaInstituicao vaga;
  const _CardVaga({required this.vaga});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        title: Text(vaga.cargo,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(vaga.descricao),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TelaDetalheVaga(vaga: vaga)),
          );
        },
      ),
    );
  }
}

class _CardRecompensa extends StatelessWidget {
  final Recompensa recompensa;
  const _CardRecompensa({required this.recompensa});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.emoji_events, color: Colors.amber[700], size: 32),
        title: Text(recompensa.titulo,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${recompensa.descricao}\nRecebida em: ${DateFormat('dd/MM/yyyy').format(recompensa.data)}',
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _CardFeedback extends StatelessWidget {
  final FeedbackModel feedback;
  const _CardFeedback({required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.feedback, color: Colors.deepPurple[800]),
        title: Text(feedback.mensagem),
        subtitle: Text(DateFormat('dd/MM/yyyy – HH:mm').format(feedback.data)),
      ),
    );
  }
}
