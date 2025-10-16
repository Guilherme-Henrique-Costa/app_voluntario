import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/storage_service.dart';
import '../models/recomendacao_model.dart';
import '../services/recomendacao_service.dart';
import 'tela_detalhe_recomendacao.dart';

class TelaRecomendacoes extends StatefulWidget {
  const TelaRecomendacoes({super.key});

  @override
  State<TelaRecomendacoes> createState() => _TelaRecomendacoesState();
}

class _TelaRecomendacoesState extends State<TelaRecomendacoes> {
  Future<RecomendacaoModel>? _futureRecomendacoes;

  @override
  void initState() {
    super.initState();
    _carregarRecomendacoes();
  }

  Future<void> _carregarRecomendacoes() async {
    final voluntario = await StorageService.obterAtual();
    if (voluntario?.id != null) {
      setState(() {
        _futureRecomendacoes =
            RecomendacaoService().fetchRecomendacoes(voluntario!.id!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Recomendações Inteligentes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          _background(),
          FutureBuilder<RecomendacaoModel>(
            future: _futureRecomendacoes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset('assets/animations/loading.json',
                      height: 120),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar recomendações:\n${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'Nenhuma recomendação disponível no momento.',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              final dados = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _secaoTitulo('🎯 Vagas Recomendadas'),
                    const SizedBox(height: 10),
                    _buildListaVagas(dados.vagasRecomendadas),
                    const SizedBox(height: 30),
                    _secaoTitulo('🏅 Recompensas Próximas'),
                    const SizedBox(height: 10),
                    ...dados.recompensasProximas.map(_cardRecompensa),
                    const SizedBox(height: 30),
                    _secaoTitulo('🌱 Causas Mais Engajadas'),
                    const SizedBox(height: 10),
                    ...dados.causasMaisEngajadas.map(_cardCausa),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _background() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade300,
              Colors.deepPurple.shade900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );

  Widget _secaoTitulo(String titulo) => Text(
        titulo,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.amber,
        ),
      );

  // --- VAGAS RECOMENDADAS ---
  Widget _buildListaVagas(List<VagaRecomendada> vagas) {
    if (vagas.isEmpty) {
      return const Text(
        'Nenhuma vaga recomendada no momento.',
        style: TextStyle(color: Colors.white70),
      );
    }

    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: vagas.length,
        itemBuilder: (context, i) {
          final vaga = vagas[i];
          return Container(
            width: 230,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vaga.titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Causa: ${vaga.causa}',
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black87)),
                  Text('Local: ${vaga.localidade}',
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black87)),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TelaDetalheRecomendacao(vaga: vaga),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_ios, size: 14),
                      label: const Text('Ver mais'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- RECOMPENSAS PRÓXIMAS ---
  Widget _cardRecompensa(RecompensaProxima r) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              r.titulo,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            LinearPercentIndicator(
              lineHeight: 10,
              percent: (r.progresso.clamp(0, 100)) / 100,
              backgroundColor: Colors.grey[300],
              progressColor: Colors.amber,
              barRadius: const Radius.circular(8),
              animation: true,
            ),
            const SizedBox(height: 6),
            Text('${r.progresso}% concluído',
                style: TextStyle(color: Colors.grey[700], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // --- CAUSAS MAIS ENGAJADAS ---
  Widget _cardCausa(CausaEngajada c) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const Icon(Icons.favorite, color: Colors.amber),
      title: Text(
        c.causa,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      trailing: Text(
        '${c.participacoes} participações',
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
