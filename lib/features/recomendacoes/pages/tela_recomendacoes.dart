import 'package:app_voluntario/core/constants/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/recomendacao_model.dart';
import '../services/recomendacao_service.dart';

class TelaRecomendacoes extends StatefulWidget {
  @override
  _TelaRecomendacoesState createState() => _TelaRecomendacoesState();
}

class _TelaRecomendacoesState extends State<TelaRecomendacoes> {
  late Future<RecomendacaoModel> _futureRecomendacoes;

  @override
  void initState() {
    super.initState();
    _carregarRecomendacoes();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recomendações Inteligentes'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<RecomendacaoModel>(
        future: _futureRecomendacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Nenhuma recomendação encontrada.'));
          }

          final dados = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSecaoTitulo('🎯 Vagas Recomendadas'),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dados.vagasRecomendadas.length,
                    itemBuilder: (context, index) {
                      final vaga = dados.vagasRecomendadas[index];
                      return _buildCardVaga(vaga);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _buildSecaoTitulo('🏅 Recompensas Próximas'),
                ...dados.recompensasProximas.map(_buildCardRecompensa),
                const SizedBox(height: 24),
                _buildSecaoTitulo('🌱 Causas mais engajadas'),
                ...dados.causasMaisEngajadas.map(_buildCardCausa),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSecaoTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        titulo,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCardVaga(VagaRecomendada vaga) {
    return Container(
      width: 220,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vaga.titulo,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Causa: ${vaga.causa}', style: TextStyle(fontSize: 14)),
            Text('Local: ${vaga.localidade}', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildCardRecompensa(RecompensaProxima recompensa) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recompensa.titulo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearPercentIndicator(
              lineHeight: 10,
              percent: recompensa.progresso / 100,
              backgroundColor: Colors.grey[300]!,
              progressColor: Colors.deepPurple,
              animation: true,
              barRadius: Radius.circular(6),
            ),
            const SizedBox(height: 4),
            Text('${recompensa.progresso}% concluído',
                style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildCardCausa(CausaEngajada causa) {
    return ListTile(
      leading: Icon(Icons.favorite, color: Colors.purple),
      title: Text(causa.causa),
      trailing: Text('${causa.participacoes} participações'),
    );
  }
}
