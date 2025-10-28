import 'package:flutter/material.dart';
import 'package:app_voluntario/features/vagas/models/vaga_instituicao_model.dart';
import 'package:app_voluntario/features/vagas/pages/tela_detalhe_vaga.dart';
import 'package:app_voluntario/shared/widgets/app_card.dart';

class CardVaga extends StatelessWidget {
  final VagaInstituicao vaga;

  const CardVaga({super.key, required this.vaga});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TelaDetalheVaga(vaga: vaga)),
      ),
      child: ListTile(
        title: Text(
          vaga.cargo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle:
            Text(vaga.descricao, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }
}
