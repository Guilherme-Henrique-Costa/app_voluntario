import 'package:flutter/material.dart';
import '../models/recomendacao_model.dart';

class CardCausa extends StatelessWidget {
  final CausaEngajada causa;

  const CardCausa({super.key, required this.causa});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const Icon(Icons.favorite, color: Colors.amber),
      title: Text(
        causa.causa,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      trailing: Text(
        '${causa.participacoes} participações',
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
