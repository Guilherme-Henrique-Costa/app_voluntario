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

  void _carregarEstatisticas() async {
    final voluntario = await StorageService.obterAtual();
    if (voluntario != null && voluntario.id != null) {
      setState(() {
        _futureEstatisticas =
            DashboardService().fetchEstatisticas(voluntario.id!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _futureEstatisticas == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<EstatisticasModel>(
              future: _futureEstatisticas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('Erro ao carregar dados.'));
                }

                final dados = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildIndicadores(dados),
                      const SizedBox(height: 30),
                      Text(
                        'Distribuição das últimas atividades (em horas)',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Expanded(child: _buildGraficoPizza(dados)),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildIndicadores(EstatisticasModel dados) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIndicador('Horas', dados.totalHoras.toString()),
        _buildIndicador('Vagas', dados.vagasCompletadas.toString()),
        _buildIndicador('Pontos', dados.pontuacao.toString()),
      ],
    );
  }

  Widget _buildIndicador(String label, String valor) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.black87)),
      ],
    );
  }

  Widget _buildGraficoPizza(EstatisticasModel dados) {
    final total = dados.evolucaoSemanal.fold(0, (a, b) => a + b);
    if (total == 0) {
      return const Center(child: Text('Sem dados para mostrar.'));
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
            radius: 60,
            titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
          );
        }).toList(),
      ),
    );
  }
}
