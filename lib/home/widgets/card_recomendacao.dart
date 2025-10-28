import 'package:flutter/material.dart';
import 'package:app_voluntario/features/recomendacoes/models/recomendacao_model.dart';
import 'package:app_voluntario/shared/widgets/app_card.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CardRecomendacao extends StatelessWidget {
  final RecomendacaoModel recomendacao;
  final VoidCallback? onVerMais;

  const CardRecomendacao({
    super.key,
    required this.recomendacao,
    this.onVerMais,
  });

  @override
  Widget build(BuildContext context) {
    final vagas = recomendacao.vagasRecomendadas.take(2).toList();
    final recompensas = recomendacao.recompensasProximas.take(1).toList();
    final causas = recomendacao.causasMaisEngajadas.take(1).toList();

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.recommend, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text(
                'Recomendações Inteligentes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Vagas recomendadas
          ...vagas.map(
            (v) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                v.titulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${v.causa} • ${v.localidade}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),

          // Recompensa próxima
          ...recompensas.map(
            (r) => Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearPercentIndicator(
                    lineHeight: 8,
                    percent: (r.progresso / 100).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[300],
                    progressColor: Colors.amber,
                    animation: true,
                    barRadius: const Radius.circular(6),
                  ),
                ],
              ),
            ),
          ),

          // Causa engajada
          ...causas.map(
            (c) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.favorite, color: Colors.pink),
              title: Text(c.causa),
              trailing: Text('${c.participacoes}x'),
            ),
          ),

          if (onVerMais != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onVerMais,
                child: const Text(
                  'Ver todas →',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
