import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_theme.dart';
import '../../../core/constants/storage_service.dart';
import '../models/vaga_candidatada_model.dart';
import '../services/candidatura_service.dart';
import '../widgets/card_vaga_historico.dart';

class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});

  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  late Future<List<VagaCandidatada>> _futureCandidaturas;

  @override
  void initState() {
    super.initState();
    _futureCandidaturas = _carregarCandidaturas();
  }

  Future<List<VagaCandidatada>> _carregarCandidaturas() async {
    final voluntario = await StorageService.obterAtual();
    if (voluntario?.id == null) {
      throw Exception('Voluntário não encontrado.');
    }
    return CandidaturaService().buscarCandidaturasDoVoluntario(voluntario!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Candidaturas'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFAF5FF),
              Color(0xFFE4D9FF),
              Color(0xFFD1C0FF),
            ],
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

            final candidaturas = snapshot.data ?? [];
            if (candidaturas.isEmpty) {
              return _semDados();
            }

            // Ordena por data de candidatura (mais recentes primeiro)
            candidaturas.sort((a, b) {
              final dataA = a.dataCandidatura ?? DateTime(1900);
              final dataB = b.dataCandidatura ?? DateTime(1900);
              return dataB.compareTo(dataA);
            });

            return _listaCandidaturas(candidaturas);
          },
        ),
      ),
    );
  }

  // ==================== COMPONENTES ====================

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
              'Erro ao carregar histórico:\n$erro',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textDark,
                    height: 1.4,
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
            'Você ainda não se candidatou a nenhuma vaga 🌱',
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

  Widget _listaCandidaturas(List<VagaCandidatada> candidaturas) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: candidaturas.length,
      itemBuilder: (context, i) {
        final vaga = candidaturas[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: CardVagaHistorico(vaga: vaga),
        );
      },
    );
  }
}
