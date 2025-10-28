import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/constants/storage_service.dart';
import '../models/vaga_candidatada_model.dart';
import '../services/candidatura_service.dart';
import '../widgets/card_vaga_candidatada.dart';
import 'tela_detalhe_vaga.dart';

class TelaMinhasVagas extends StatefulWidget {
  const TelaMinhasVagas({super.key});

  @override
  State<TelaMinhasVagas> createState() => _TelaMinhasVagasState();
}

class _TelaMinhasVagasState extends State<TelaMinhasVagas> {
  late Future<List<VagaCandidatada>> _futureCandidaturas;
  final _service = CandidaturaService();

  @override
  void initState() {
    super.initState();
    _futureCandidaturas = _carregarCandidaturas();
  }

  Future<List<VagaCandidatada>> _carregarCandidaturas() async {
    final voluntario = await StorageService.obterAtual();
    if (voluntario?.id == null) throw Exception('Voluntário não encontrado');
    return await _service.buscarCandidaturasDoVoluntario(voluntario!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Vagas')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFE4D9FF), Color(0xFFD1C0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<VagaCandidatada>>(
          future: _futureCandidaturas,
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
              'Erro ao carregar candidaturas:\n$erro',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textDark,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton.icon(
              onPressed: () =>
                  setState(() => _futureCandidaturas = _carregarCandidaturas()),
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
            'Você ainda não se candidatou a nenhuma vaga 💼',
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

  Widget _listaVagas(List<VagaCandidatada> vagas) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: vagas.length,
      itemBuilder: (context, i) {
        final vaga = vagas[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: CardVagaCandidatada(
            vaga: vaga,
            onVerDetalhes: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TelaDetalheVaga(vaga: vaga)),
              );
            },
            onCancelar: () async {
              final voluntario = await StorageService.obterAtual();
              if (voluntario == null) return;
              final sucesso =
                  await _service.cancelarCandidatura(vaga.id, voluntario.id!);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    sucesso
                        ? 'Candidatura cancelada com sucesso!'
                        : 'Erro ao cancelar candidatura.',
                  ),
                  backgroundColor:
                      sucesso ? AppColors.success : AppColors.error,
                ),
              );

              if (sucesso) {
                setState(() => _futureCandidaturas = _carregarCandidaturas());
              }
            },
          ),
        );
      },
    );
  }
}
