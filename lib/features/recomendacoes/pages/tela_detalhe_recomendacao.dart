import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/storage_service.dart';
import '../../../features/vagas/services/candidatura_service.dart';
import '../models/recomendacao_model.dart';

class TelaDetalheRecomendacao extends StatelessWidget {
  final VagaRecomendada vaga;

  const TelaDetalheRecomendacao({super.key, required this.vaga});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Detalhes da Vaga',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          _background(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                _tituloVaga(),
                const SizedBox(height: 20),
                _cardInfo('Causa', vaga.causa, Icons.favorite),
                _cardInfo('Local', vaga.localidade, Icons.location_on),
                const SizedBox(height: 30),
                _descricao(),
                const SizedBox(height: 30),
                _botaoParticipar(context),
                const SizedBox(height: 40),
                Center(
                  child: Lottie.asset(
                    'assets/animations/helping.json',
                    height: 160,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );

  Widget _tituloVaga() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vaga.titulo,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Confira as informações e veja se essa vaga combina com você!',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      );

  Widget _cardInfo(String label, String valor, IconData icone) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(icone, color: Colors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(valor,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 15, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _descricao() => const Text(
        'Descrição detalhada da vaga:\n\n'
        'Esta oportunidade foi selecionada especialmente para o seu perfil, '
        'com base nas causas que você apoia e nas suas habilidades cadastradas. '
        'Participe dessa ação voluntária e contribua com sua comunidade!',
        style: TextStyle(color: Colors.white, height: 1.5, fontSize: 15),
      );

  Widget _botaoParticipar(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async => _enviarCandidatura(context),
        icon: const Icon(Icons.handshake, color: Colors.deepPurple),
        label: const Text(
          'Quero Participar',
          style: TextStyle(color: Colors.deepPurple, fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Future<void> _enviarCandidatura(BuildContext context) async {
    final voluntario = await StorageService.obterAtual();

    if (voluntario == null || voluntario.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: usuário não autenticado.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final sucesso = await CandidaturaService().candidatar(
      vagaId: vaga.id,
      voluntarioId: voluntario.id!,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: sucesso ? Colors.green : Colors.redAccent,
        content: Text(
          sucesso
              ? '✅ Candidatura enviada com sucesso!'
              : '❌ Erro ao enviar candidatura.',
        ),
      ),
    );
  }
}
