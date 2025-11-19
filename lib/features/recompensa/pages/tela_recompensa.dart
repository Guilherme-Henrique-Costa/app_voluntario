import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_theme.dart';
import 'tela_conquistas.dart';
import 'tela_historico_recompensa.dart';

class TelaRecompensa extends StatefulWidget {
  const TelaRecompensa({super.key});

  @override
  State<TelaRecompensa> createState() => _TelaRecompensaState();
}

class _TelaRecompensaState extends State<TelaRecompensa> {
  bool _recompensaRecebida = false;

  void _receberRecompensa() {
    setState(() => _recompensaRecebida = true);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Parabéns! 🎉'),
        content: const Text(
          'Sua recompensa foi registrada com sucesso.\nContinue fazendo a diferença!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recompensa')),
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _recompensaRecebida
                      ? Lottie.asset(
                          'assets/animations/congrats.json',
                          width: 200,
                          height: 200,
                        )
                      : const Icon(
                          Icons.emoji_events,
                          size: 100,
                          color: AppColors.secondary,
                        ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    _recompensaRecebida
                        ? 'Recompensa Recebida! 👏'
                        : 'Obrigado por fazer a diferença!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title
                        .copyWith(color: AppColors.textLight),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Você contribuiu para uma causa importante.\n'
                    'Como reconhecimento, resgate sua recompensa agora.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textLight, fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton.icon(
                    onPressed: _recompensaRecebida ? null : _receberRecompensa,
                    icon: const Icon(Icons.card_giftcard),
                    label: const Text('Receber Recompensa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.textDark,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(color: Colors.white54, thickness: 0.8),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TelaConquistas()),
                    ),
                    icon: const Icon(Icons.military_tech),
                    label: const Text('Ver Conquistas / Medalhas'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      foregroundColor: AppColors.textLight,
                      side: const BorderSide(color: AppColors.textLight),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TelaHistoricoRecompensas()),
                    ),
                    icon: const Icon(Icons.history),
                    label: const Text('Ver Histórico de Recompensas'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      foregroundColor: AppColors.textLight,
                      side: const BorderSide(color: AppColors.textLight),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
