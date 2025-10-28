import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_voluntario/features/recompensa/models/recompensa.dart';
import 'package:app_voluntario/shared/widgets/app_card.dart';

class CardRecompensa extends StatelessWidget {
  final Recompensa recompensa;

  const CardRecompensa({super.key, required this.recompensa});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: ListTile(
        leading: Icon(Icons.emoji_events, color: Colors.amber[700], size: 32),
        title: Text(
          recompensa.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${recompensa.descricao}\nRecebida em: ${DateFormat('dd/MM/yyyy').format(recompensa.data)}',
        ),
        isThreeLine: true,
      ),
    );
  }
}
