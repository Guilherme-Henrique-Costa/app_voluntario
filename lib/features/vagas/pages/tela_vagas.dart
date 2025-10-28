import 'package:app_voluntario/features/vagas/pages/tela_detalhe_vaga.dart';
import 'package:app_voluntario/features/vagas/services/vaga_instituicao_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_theme.dart';
import '../models/vaga_instituicao_model.dart';
import '../widgets/card_vaga_disponivel.dart';

class TelaVagas extends StatefulWidget {
  const TelaVagas({super.key});

  @override
  State<TelaVagas> createState() => _TelaVagasState();
}

class _TelaVagasState extends State<TelaVagas> {
  late Future<List<VagaInstituicao>> _futureVagas;

  @override
  void initState() {
    super.initState();
    _futureVagas = _carregarVagas();
  }

  Future<List<VagaInstituicao>> _carregarVagas() async {
    return await VagaInstituicaoService().listarVagasDisponiveis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vagas Disponíveis')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFE4D9FF), Color(0xFFD1C0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<VagaInstituicao>>(
          future: _futureVagas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child:
                    Lottie.asset('assets/animations/loading.json', height: 120),
              );
            }

            if (snapshot.hasError) {
              return _erro(snapshot.error.toString());
            }

            final vagas = snapshot.data ?? [];
            if (vagas.isEmpty) {
              return _semDados();
            }

            return _listaVagas(vagas);
          },
        ),
      ),
    );
  }

  Widget _erro(String erro) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/error.json', height: 140),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Erro ao carregar vagas:\n$erro',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textDark,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton.icon(
              onPressed: () => setState(() => _futureVagas = _carregarVagas()),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _semDados() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Nenhuma vaga disponível no momento 🌱',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight.withOpacity(0.8),
                  height: 1.4,
                ),
          ),
        ),
      ),
    );
  }

  Widget _listaVagas(List<VagaInstituicao> vagas) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: vagas.length,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: CardVagaDisponivel(
          vaga: vagas[i],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TelaDetalheVaga(vaga: vagas[i]),
              ),
            );
          },
        ),
      ),
    );
  }
}
