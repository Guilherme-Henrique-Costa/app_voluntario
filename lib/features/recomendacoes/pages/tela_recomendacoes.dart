import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/constants/storage_service.dart';
import '../models/recomendacao_model.dart';
import '../services/recomendacao_service.dart';
import '../widgets/card_vaga.dart';
import '../widgets/card_recompensa.dart';
import '../widgets/card_causa.dart';
import '../widgets/secao_titulo.dart';

class TelaRecomendacoes extends StatefulWidget {
  const TelaRecomendacoes({super.key});

  @override
  State<TelaRecomendacoes> createState() => _TelaRecomendacoesState();
}

class _TelaRecomendacoesState extends State<TelaRecomendacoes> {
  late Future<List<RecomendacaoModel>> _futureRecomendacoes;

  @override
  void initState() {
    super.initState();
    _futureRecomendacoes = _carregarRecomendacoes();
  }

  Future<List<RecomendacaoModel>> _carregarRecomendacoes() async {
    final voluntario = await StorageService.obterAtual();
    if (voluntario?.id == null) {
      throw Exception('Voluntário não encontrado.');
    }
    return RecomendacaoService().buscarRecomendacoes(voluntario!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendações Inteligentes'),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<RecomendacaoModel>>(
          future: _futureRecomendacoes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  height: 120,
                ),
              );
            }

            if (snapshot.hasError) {
              return _buildErro(snapshot.error.toString());
            }

            final recomendacoes = snapshot.data;
            if (recomendacoes == null || recomendacoes.isEmpty) {
              return _buildSemDados();
            }

            final dados = recomendacoes.first;
            return _buildConteudo(dados);
          },
        ),
      ),
    );
  }

  // ==================== ESTADOS DE TELA ====================

  Widget _buildErro(String mensagem) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/error.json', height: 140),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Erro ao carregar recomendações:\n$mensagem',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.textLight),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton.icon(
              onPressed: () => setState(
                  () => _futureRecomendacoes = _carregarRecomendacoes()),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemDados() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.card.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Nenhuma recomendação disponível no momento 🌱',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textLight.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  // ==================== CONTEÚDO PRINCIPAL ====================

  Widget _buildConteudo(RecomendacaoModel dados) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Seção: Vagas
          const SecaoTitulo(
            icon: Icons.work_outline,
            titulo: 'Vagas Recomendadas',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildListaVagas(dados.vagasRecomendadas),

          const SizedBox(height: AppSpacing.xl),

          // 🔹 Seção: Recompensas
          const SecaoTitulo(
            icon: Icons.emoji_events_outlined,
            titulo: 'Recompensas Próximas',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildListaRecompensas(dados.recompensasProximas),

          const SizedBox(height: AppSpacing.xl),

          // 🔹 Seção: Causas
          const SecaoTitulo(
            icon: Icons.favorite_border,
            titulo: 'Causas Mais Engajadas',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildListaCausas(dados.causasMaisEngajadas),
        ],
      ),
    );
  }

  // ==================== CONTEÚDO DAS SEÇÕES ====================

  Widget _buildListaVagas(List<VagaRecomendada> vagas) {
    if (vagas.isEmpty) return _mensagemVazia('Nenhuma vaga recomendada');
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: vagas.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, i) => CardVaga(vaga: vagas[i]),
      ),
    );
  }

  Widget _buildListaRecompensas(List<RecompensaProxima> recompensas) {
    if (recompensas.isEmpty) {
      return _mensagemVazia('Nenhuma recompensa próxima');
    }
    return Column(
      children: recompensas
          .map((r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: CardRecompensa(recompensa: r),
              ))
          .toList(),
    );
  }

  Widget _buildListaCausas(List<CausaEngajada> causas) {
    if (causas.isEmpty) {
      return _mensagemVazia('Nenhuma causa engajada encontrada');
    }
    return Column(
      children: causas
          .map((c) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: CardCausa(causa: c),
              ))
          .toList(),
    );
  }

  Widget _mensagemVazia(String texto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: AppTextStyles.body.copyWith(
          color: AppColors.textLight.withOpacity(0.8),
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
