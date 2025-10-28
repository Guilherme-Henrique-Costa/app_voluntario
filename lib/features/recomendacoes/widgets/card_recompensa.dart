import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/recomendacao_model.dart';

class CardRecompensa extends StatelessWidget {
  final RecompensaProxima recompensa;

  const CardRecompensa({super.key, required this.recompensa});

  @override
  Widget build(BuildContext context) {
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
              recompensa.titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            LinearPercentIndicator(
              lineHeight: 10,
              percent: (recompensa.progresso.clamp(0, 100)) / 100,
              backgroundColor: Colors.grey[300],
              progressColor: Colors.amber,
              barRadius: const Radius.circular(8),
              animation: true,
            ),
            const SizedBox(height: 6),
            Text(
              '${recompensa.progresso}% concluído',
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
