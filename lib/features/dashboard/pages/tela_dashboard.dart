import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_voluntario/features/dashboard/models/estatisticas_model.dart';
import 'package:app_voluntario/features/dashboard/services/dashboard_service.dart';
import 'package:app_voluntario/core/constants/storage_service.dart';

class TelaDashboard extends StatefulWidget {
  const TelaDashboard({super.key});

  @override
  State<TelaDashboard> createState() => _TelaDashboardState();
}

class _TelaDashboardState extends State<TelaDashboard> {
  Future<EstatisticasModel>? _futureEstatisticas;

  @override
  void initState() {
    super.initState();
    _carregarEstatisticas();
  }

  Future<void> _carregarEstatisticas() async {
    final voluntario = await StorageService.obterAtual();
    if (voluntario?.id != null) {
      setState(() {
        _futureEstatisticas =
            DashboardService().fetchEstatisticas(voluntario!.id!);
      });
    }
  }

  // ===========================================================
  // CONSTRUÇÃO DA TELA
  // ===========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Desempenho'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<EstatisticasModel>(
          future: _futureEstatisticas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              );
            } else if (snapshot.hasError) {
              return _erroWidget();
            } else if (!snapshot.hasData) {
              return _semDadosWidget();
            }

            final dados = snapshot.data!;
            return _buildDashboard(dados);
          },
        ),
      ),
    );
  }

  // ===========================================================
  // SEÇÕES VISUAIS
  // ===========================================================
  Widget _buildDashboard(EstatisticasModel dados) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIndicadores(dados),
          const SizedBox(height: 30),
          const Text(
            'Distribuição de Horas nas Últimas Atividades',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildGraficoPizza(dados)),
        ],
      ),
    );
  }

  Widget _buildIndicadores(EstatisticasModel dados) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCardIndicador('Horas', dados.totalHoras.toString(), Icons.timer),
        _buildCardIndicador('Vagas', dados.vagasCompletadas.toString(),
            Icons.volunteer_activism),
        _buildCardIndicador(
            'Pontos', dados.pontuacao.toString(), Icons.star_rate_rounded),
      ],
    );
  }

  Widget _buildCardIndicador(String label, String valor, IconData icone) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icone, color: Colors.deepPurple, size: 28),
          const SizedBox(height: 6),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildGraficoPizza(EstatisticasModel dados) {
    final total = dados.evolucaoSemanal.fold(0, (a, b) => a + b);
    if (total == 0) {
      return const Center(
        child: Text(
          'Sem dados para mostrar.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: dados.evolucaoSemanal.asMap().entries.map((entry) {
          final index = entry.key;
          final valor = entry.value;
          final percentual = total == 0 ? 0 : valor / total * 100;

          return PieChartSectionData(
            color: Colors.primaries[index % Colors.primaries.length],
            value: valor.toDouble(),
            title: '${percentual.toStringAsFixed(1)}%',
            radius: 70,
            titleStyle: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _erroWidget() => const Center(
        child: Text(
          'Erro ao carregar dados.\nVerifique sua conexão.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
      );

  Widget _semDadosWidget() => const Center(
        child: Text(
          'Nenhuma estatística disponível no momento.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
      );
}
