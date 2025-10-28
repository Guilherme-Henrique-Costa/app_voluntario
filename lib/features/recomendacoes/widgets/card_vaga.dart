import 'package:app_voluntario/features/vagas/pages/tela_detalhe_vaga.dart';
import 'package:flutter/material.dart';
import '../models/recomendacao_model.dart';

class CardVaga extends StatelessWidget {
  final VagaRecomendada vaga;

  const CardVaga({super.key, required this.vaga});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vaga.titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 6),
            Text('Causa: ${vaga.causa}',
                style: const TextStyle(fontSize: 13, color: Colors.black87)),
            Text('Local: ${vaga.localidade}',
                style: const TextStyle(fontSize: 13, color: Colors.black87)),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TelaDetalheVaga(vaga: vaga),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward_ios, size: 14),
                label: const Text('Ver mais'),
                style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
