import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ───── Controllers ─────
import 'package:app_voluntario/home/controllers/tela_inicial_controller.dart';

// ───── Widgets (Home) ─────
import 'package:app_voluntario/home/widgets/card_vaga.dart';
import 'package:app_voluntario/home/widgets/card_feedback.dart';
import 'package:app_voluntario/home/widgets/card_recompensa.dart';
import 'package:app_voluntario/home/widgets/card_recomendacao.dart';
import 'package:app_voluntario/home/widgets/card_estatistica.dart';

// ───── Features ─────
import 'package:app_voluntario/features/vagas/services/vaga_instituicao_service.dart';
import 'package:app_voluntario/features/vagas/models/vaga_instituicao_model.dart';
import 'package:app_voluntario/features/feedback/services/feedback_service.dart';
import 'package:app_voluntario/features/feedback/models/feedback_model.dart';
import 'package:app_voluntario/features/recompensa/models/recompensa.dart';

// ───── Shared Widgets ─────
import 'package:app_voluntario/shared/widgets/loading_indicator.dart';
import 'package:app_voluntario/shared/widgets/error_message.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  void initState() {
    super.initState();

    /// 🔧 Garante que o controller só atualize após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TelaInicialController>().inicializar(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TelaInicialController>();
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.recarregar(context),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildHeader(controller),
              _buildGridAtalhos(context, largura),

              // ───────── RECOMENDAÇÕES ─────────
              if (controller.carregando)
                const SliverToBoxAdapter(
                    child:
                        Center(child: LoadingIndicator(text: 'Carregando...')))
              else if (controller.erro != null)
                SliverToBoxAdapter(
                  child: ErrorMessage(
                    text: controller.erro!,
                    onRetry: () => controller.carregarRecomendacoes(context),
                  ),
                )
              else if (controller.recomendacoes.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: CardRecomendacao(
                      recomendacao: controller.recomendacoes.first,
                      onVerMais: () =>
                          Navigator.pushNamed(context, '/recomendacoes'),
                    ),
                  ),
                ),

              // ───────── OUTRAS SEÇÕES ─────────
              _buildVagasSection(),
              _buildRecompensasSection(),
              _buildFeedbacksSection(),
              _buildEstatisticasSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────── HEADER ────────────────────────────────
  SliverToBoxAdapter _buildHeader(TelaInicialController controller) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Olá, ${controller.nomeUsuario ?? 'Voluntário'}!',
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
              onPressed: () => Navigator.pushNamed(context, '/perfil'),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────── ATALHOS ────────────────────────────────
  Widget _buildGridAtalhos(BuildContext context, double largura) {
    final atalhos = [
      _buildAtalho(context, Icons.work, 'Vagas', '/vagas'),
      _buildAtalho(context, Icons.calendar_today, 'Agenda', '/agenda'),
      _buildAtalho(context, Icons.emoji_events, 'Recompensas', '/recompensa'),
      _buildAtalho(context, Icons.feedback, 'Feedback', '/feedback'),
      _buildAtalho(context, Icons.feedback_outlined, 'Feedbacks', '/feedbacks'),
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
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
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

  // ──────────────────────────────── VAGAS ────────────────────────────────
  Widget _buildVagasSection() {
    return FutureBuilder<List<VagaInstituicao>>(
      future: VagaInstituicaoService().listarVagasDisponiveis(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
              child:
                  Center(child: LoadingIndicator(text: 'Carregando vagas...')));
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
              child: ErrorMessage(text: 'Erro ao carregar vagas.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
              child: Center(child: Text('Nenhuma vaga disponível.')));
        }

        final vagas = snapshot.data!.take(2).toList();

        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                    icon: Icons.star, title: 'Vagas em Destaque'),
                const SizedBox(height: 10),
                ...vagas.map((v) => CardVaga(vaga: v)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/vagas'),
                    child: const Text('Ver todas →',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const Divider(color: Colors.white70),
              ],
            ),
          ),
        );
      },
    );
  }

  // ──────────────────────────────── RECOMPENSAS ────────────────────────────────
  SliverToBoxAdapter _buildRecompensasSection() {
    final recompensas = [
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

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
                icon: Icons.card_giftcard, title: 'Suas Recompensas'),
            const SizedBox(height: 10),
            ...recompensas.map((r) => CardRecompensa(recompensa: r)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/recompensa'),
                child: const Text('Ver todas →',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const Divider(color: Colors.white70),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────── FEEDBACKS ────────────────────────────────
  Widget _buildFeedbacksSection() {
    return FutureBuilder<List<FeedbackModel>>(
      future: FeedbackService.listarFeedbacks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
              child: Center(
                  child: LoadingIndicator(text: 'Carregando feedbacks...')));
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
              child: ErrorMessage(text: 'Erro ao carregar feedbacks.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
              child: Center(child: Text('Nenhum feedback disponível.')));
        }

        final feedbacks = snapshot.data!.reversed.take(2).toList();

        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                    icon: Icons.feedback, title: 'Feedbacks Recentes'),
                const SizedBox(height: 10),
                ...feedbacks.map((f) => CardFeedback(feedback: f)),
                const Divider(color: Colors.white70),
              ],
            ),
          ),
        );
      },
    );
  }

  // ──────────────────────────────── ESTATÍSTICAS ────────────────────────────────
  SliverToBoxAdapter _buildEstatisticasSection() {
    final estatisticas = [
      {'label': 'Horas Voluntárias', 'valor': '24h'},
      {'label': 'Vagas Concluídas', 'valor': '6'},
      {'label': 'Recompensas', 'valor': '3'},
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: CardEstatistica(estatisticas: estatisticas),
      ),
    );
  }
}

// ──────────────────────────────── COMPONENTE AUXILIAR ────────────────────────────────
class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}
